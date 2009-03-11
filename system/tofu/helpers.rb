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

    module Paginate
      class Paginator
        private
        
        def link(n, text = n, hash = {})
          text = h(text.to_s)
          hash[:href] = R(Ramaze::Controller.current, n)
          g.a(hash){ text }
        end
      end
    end
  end
end
