module Ramaze
  module Helper
    module Form
      def form_field(datatype, options)
        name, value = options[:name], options[:value]
        case datatype
        when 'text', 'markdown' then %Q[<textarea name="#{name}">#{value}</textarea>]
        else %Q[<input type="text" name="#{name}" value="#{value}" />]
        end
      end
    end
  end
end
