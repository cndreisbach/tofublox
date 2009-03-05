module Ramaze
  module Helper
    module Form
      def form_field(datatype, options)
        case datatype
        when 'text', 'markdown' then %Q[<textarea name="#{options[:name]}">#{options[:value]}</textarea>]
        else %Q[<input type="text" name="#{options[:name]}" value="#{options[:value]}" />]
        end
      end
    end
  end
end
