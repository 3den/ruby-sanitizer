require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sanitizer do
  
  describe "sanitize" do
   
    it "should strip all tags" do
      html = "<div><p>Oi <b>como</b> <a href='/xxx/'>Vai</a></p><!-- s --></div>" 
      output = Sanitizer.sanitize(html)
      output.should == 'Oi como Vai'
    end
    
    it "should clean spaces and tags" do
      html = "<p>Oi <b>como</b>     
    Vai</p>"
      output = Sanitizer.sanitize(html)
      output.should == 'Oi como Vai'
    end
    
    it "should clean '&' entries" do
      html = "Eu & você"
      output = Sanitizer.sanitize(html)
      output.should == 'Eu &amp; você'
    end
    
    it "should not remove valid entries" do
      html = "Eu &amp; você"
      output = Sanitizer.sanitize(html)
      output.should == 'Eu &amp; você'
    end

    it "should convert invalid chars to html entries"
      text = "João foi caçar"
      output = Sanitizer.html_escape(text)
      output.should == "João foi caçar"
  end
  
  describe "strip_tags" do
    
    it "should remove only <b> tags" do
       html = "<p>Oi <b>como</b> <a href='/xxx/'>Vai</a></p><!-- s -->" 
      output = Sanitizer.strip_tags(html, 'b')
      output.should == "<p>Oi como <a href='/xxx/'>Vai</a></p><!-- s -->"
    end
    
    it "should remove only <b> and <a> tags" do
       html = "<p>Oi <b>como</b> <a href='/xxx/'>Vai</a></p><!-- s -->" 
      output = Sanitizer.strip_tags(html, 'a', 'b')
      output.should == "<p>Oi como Vai</p><!-- s -->"
    end
  end
end
