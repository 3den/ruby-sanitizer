# encoding: utf-8
module Sanitizer
  # HTMLEntris 
  @@htmle = HTMLEntities.new
  
  # All self.methods 
  class << self
    
    # Sanitize to clean text
    def sanitize!(text)
      strip_tags!(text)
      clean_spaces!(text)
      text.replace html_encode(text)
      text
    end
    
    def sanitize(text)
      sanitize! text.dup
    end
        
    # Clean retundant spaces
    def clean_spaces!(text)
      text.gsub!(/\s+/, " ")
      text.strip!
      text
    end
    
    def clean_spaces(text)
      clean_spaces! text.dup
    end
    
    # remove comments
    def strip_comments!(text)
      text.gsub!(/(\<\!\-\-\b*[^\-\-\>]*.*?\-\-\>)/ui, "")
      text.gsub!(/(\&lt;\s?\!--.*\s?--\&gt;)/uim, "")
      text
    end

    def strip_comments(text)
      strip_comments! text.dup
    end
    
    # Remove all <script> and <style> tags
    def strip_disallowed_tags!(text)
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
    
    def strip_disallowed_tags(text)
      strip_disallowed_tags! text.dup
    end 

    # Remove all tags from from text
    def strip_tags!(text, *tags)
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
    
    def strip_tags(text, *tags)
      strip_tags! text.dup, *tags
    end
    
    # Alguns feeds retornam tags "escapadas" dentro do conteúdo (ex: &lt;br/&gt;)
    # Este método deve ser utilizado após o stripping e sanitização, para não deixar que essas tags sejam exibidas como conteúdo
    def entities_to_chars!(text)
      text.gsub!(/\&lt;/uim, "<")
      text.gsub!(/\&gt;/uim, ">")
      text
    end
    
    def entities_to_chars(text)
      entities_to_chars! text.dup
    end

    # Convert invalid chars to HTML Entries
    def html_encode(text)
      text = text.to_s  
      @@htmle.encode(text, :named)
    end

    # Convert invalid chars to HTML Entries
    def html_decode(text)
      text = text.to_s  
      @@htmle.decode(text)
    end   
  end # self
end
