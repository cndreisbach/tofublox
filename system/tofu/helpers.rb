module Ramaze
  module Helper
    module Form
      def form_field(datatype, options)
        case datatype
        when 'text' then %Q[<textarea name="#{options[:name]}"></textarea>]
        else %Q[<input type="text" name="#{options[:name]}" />]
        end
      end
    end
  end
end
