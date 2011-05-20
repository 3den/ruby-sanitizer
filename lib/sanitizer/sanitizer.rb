# encoding: utf-8
module Sanitizer
  # HTMLEntris 
  @@htmle = HTMLEntities.new
  
  # All self.methods 
  class << self
    def sanitize(text)
      text = strip_tags(text)
      text = clean_spaces(text)
      text = html_encode(text)
      text
    end
        
    def clean_spaces(text)
      output = text.dup
      output.gsub!(/\s+/, " ")
      output.strip!
      output
    end
    
    def strip_comments(text)
      output = text.dup
      output.gsub!(/(\<\!\-\-\b*[^\-\-\>]*.*?\-\-\>)/ui, "")
      output.gsub!(/(\&lt;\s?\!--.*\s?--\&gt;)/uim, "")
      output
    end

    # Remove all <script> and <style> tags
    def strip_disallowed_tags(text)
      output = text
      output.gsub!(/(<script\s*.*>.*<\/script>)/uim, "")
      output.gsub!(/(<script\s*.*\/?>)/uim, "")
      output.gsub!(/(<link\s*.*\/?>)/uim, "")
      output.gsub!(/(<style\s*.*>.*<\/style>)/uim, "")

      # Stripping html entities too
      output.gsub!(/(\&lt;script\s*.*\&gt;.*\&lt;\/script\&gt;)/uim, "")
      output.gsub!(/(\&lt;script\s*.*\/?\&gt;)/uim, "")
      output.gsub!(/(\&lt;link\s*.*\/?\&gt;)/uim, "")
      output.gsub!(/(\&lt;style\s*.*\&gt;.*\&lt;\/style\&gt;)/uim, "")
      output
    end

    # Remove all tags from from text
    def strip_tags(text, *tags)
      output = text.dup
      if tags.empty? # clear all tags by default
        output.gsub!(/<\/?[^>]*>/uim, "")
        output.gsub!(/\&lt;\/?[^\&gt;]*\&gt;/uim, "")
      else # clean only selected tags 
        strip = tags.map do |tag|  
          %Q{(#{tag})}
        end.join('|')
        output.gsub!(/<\/?(#{strip})[^>]*>/uim, "")
        output.gsub!(/\&lt;\/?(#{strip})[^\&gt;]*\&gt;/uim, "")
      end
      output
    end

    # Convert invalid chars to HTML Entries
    def html_encode(text)
      text = text.to_s  
      @@htmle.encode(text, :named)
    end

    # Convert invalid chars to HTML Entries
    def html_decode(text)
      text = text.to_s  
      @@htmle.decode(text, :named)
    end
    
    # Alguns feeds retornam tags "escapadas" dentro do conteúdo (ex: &lt;br/&gt;)
    # Este método deve ser utilizado após o stripping e sanitização, para não deixar que essas tags sejam exibidas como conteúdo
    def entities_to_chars(text)
      output = text.dup
      output.gsub!(/\&lt;/uim, "<")
      output.gsub!(/\&gt;/uim, ">")
      output
    end

  end # self
end
