require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sanitizer do
  
  describe "sanitize" do  
    it "should strip all tags" do
      html = "<div><p>Oi <b>como</b> <a href='/xxx/'>Vai</a></p><!-- s --></div>" 
      output = Sanitizer.sanitize(html)
      output.should == 'Oi como Vai'
    end
    
    it "should still clean even after multiple sanitizes" do
      html = "<div>Eu & você <b>como</b> <a href='/xxx/'>Vai</a></p><!-- s --></div>" 
      output = Sanitizer.sanitize(html)
      output = Sanitizer.sanitize(output)
      output = Sanitizer.sanitize(output)
      output.should == 'Eu &amp; voc&ecirc; como Vai'
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
      output.should == "Eu &amp; voc&ecirc;"
    end
    
    it "should not remove valid entries" do
      html = "Eu &amp; você"
      output = Sanitizer.sanitize(html)
      output.should == "Eu &amp; voc&ecirc;"
    end
  end
  
  describe "html_encode" do

    it "should convert invalid chars to html entries" do
      text = "João foi caçar"
      output = Sanitizer.html_encode(text)
      output.should == "Jo&atilde;o foi ca&ccedil;ar"
    end
    
    it "should sanitize HTML tags" do
      text = "<p>João <b>foi</b> caçar</p>"
      output = Sanitizer.html_encode(text)
      output.should == "&lt;p&gt;Jo&atilde;o &lt;b&gt;foi&lt;/b&gt; ca&ccedil;ar&lt;/p&gt;"
    end
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
