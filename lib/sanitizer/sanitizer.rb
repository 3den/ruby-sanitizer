# encoding: utf-8
module Sanitizer
  # HTMLEntris 
  @@htmle = HTMLEntities.new
  
  # All self.methods 
  class << self
    def sanitize(text)
      new_text = text
      sanitize!(new_text)
    end
    
    def sanitize!(text)
      strip_tags(text)
      clean_spaces(text)
      clean_ampersand(text)
      text
    end
        
    def clean_spaces(text)
      text.gsub!(/\s+/, " ")
      text
    end
    
    def clean_ampersand(text)
      text.gsub!(/\&[^\w\;]+/, "&amp; ")
      text
    end
    
    def strip_comments(text)
      text.gsub!(/(\<\!\-\-\b*[^\-\-\>]*.*?\-\-\>)/ui, "")
      text.gsub!(/(\&lt;\s?\!--.*\s?--\&gt;)/uim, "")
      text
    end

    # Remove all <script> and <style> tags
    def strip_disallowed_tags(text)
      text.gsub!(/(<script\s*.*>.*<\/script>)/uim, "")
      text.gsub!(/(<script\s*.*\/?>)/uim, "")
      text.gsub!(/(<link\s*.*\/?>)/uim, "")
      text.gsub!(/(<style\s*.*>.*<\/style>)/uim, "")

      # Stripping html entities too
      text.gsub!(/(\&lt;script\s*.*\&gt;.*\&lt;\/script\&gt;)/uim, "")
      text.gsub!(/(\&lt;script\s*.*\/?\&gt;)/uim, "")
      text.gsub!(/(\&lt;link\s*.*\/?\&gt;)/uim, "")
      text.gsub!(/(\&lt;style\s*.*\&gt;.*\&lt;\/style\&gt;)/uim, "")
      text
    end

    # Remove all tags from from text
    def strip_tags(text, *tags)
      if tags.empty? # clear all tags by default
        text.gsub!(/<\/?[^>]*>/uim, "")
        text.gsub!(/\&lt;\/?[^\&gt;]*\&gt;/uim, "")
      else # clean only selected tags 
        strip = tags.map do |tag|  
          %Q{(#{tag})}
        end.join('|')
        text.gsub!(/<\/?(#{strip})[^>]*>/uim, "")
        text.gsub!(/\&lt;\/?(#{strip})[^\&gt;]*\&gt;/uim, "")
      end
      text
    end

    # Convert invalid chars to HTML Entries
    def html_escape(text)
      text = text.to_s
      return text if text.html_safe? 
        
      @@htmle.encode(s, :named)
    end

    # Alguns feeds retornam tags "escapadas" dentro do conteúdo (ex: &lt;br/&gt;)
    # Este método deve ser utilizado após o stripping e sanitização, para não deixar que essas tags sejam exibidas como conteúdo
    def entities_to_chars(text)
      text.gsub!(/\&lt;/uim, "<")
      text.gsub!(/\&gt;/uim, ">")
      text
    end

    #  this liftend nearly verbatim from html5
    def sanitize_css(style)
      # disallow urls
      style = style.to_s.gsub(/url\s*\(\s*[^\s)]+?\s*\)\s*/uim, ' ')

      # gauntlet
      return '' unless style =~ /^([:,;#%.\sa-zA-Z0-9!]|\w-\w|\'[\s\w]+\'|\"[\s\w]+\"|\([\d,\s]+\))*$/uim
      return '' unless style =~ /^\s*([-\w]+\s*:[^:;]*(;\s*|$))*$/uim

      clean = []
      style.scan(/([-\w]+)\s*:\s*([^:;]*)/uim) do |prop, val|
        next if val.empty?
        prop.downcase!
        if HashedWhiteList::ALLOWED_CSS_PROPERTIES[prop]
          clean << "#{prop}: #{val};"
        elsif %w[background border margin padding].include?(prop.split('-')[0])
          clean << "#{prop}: #{val};" unless val.split().any? do |keyword|
            HashedWhiteList::ALLOWED_CSS_KEYWORDS[keyword].nil? and
              keyword !~ /^(#[0-9a-f]+|rgb\(\d+%?,\d*%?,?\d*%?\)?|\d{0,2}\.?\d{0,2}(cm|em|ex|in|mm|pc|pt|px|%|,|\))?)$/uim
          end
        elsif HashedWhiteList::ALLOWED_SVG_PROPERTIES[prop]
          clean << "#{prop}: #{val};"
        end
      end

      style = clean.join(' ')
    end
  end # self
end
