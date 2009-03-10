module Tofu
  module Formatters    
    class String
      def initialize(text)
        @text = text
      end
      
      def to_html
        @text
      end
    end
    
    class Text < String
      def to_html
        start_tag = "<p>"
        text = @text.to_s.dup
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text << "</p>"
      end
    end
    
    MARKDOWNS = %w(Maruku RDiscount BlueCloth)
    
    def self.get_markdown_implementation(impls = MARKDOWNS)
      if impls.empty?
        Text
      else
        impl = impls.shift

        begin
          require impl.downcase
          Kernel.const_get(impl)
        rescue LoadError, NameError
          get_markdown_implementation(impls)
        end
      end
    end

    Markdown = get_markdown_implementation    
  end
end
