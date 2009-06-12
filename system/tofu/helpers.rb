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
        def navigation(limit = 8)
          out = [ g.div(:class => :pager) ]

          unless first_page?
            out << link(1, 'First', :class => :first)
            out << link(prev_page, '<', :class => :previous)
          end

          lower = limit ? (current_page - limit) : 1
          lower = lower < 1 ? 1 : lower

          (lower...current_page).each do |n|
            out << link(n)
          end
          
          out << g.span(:class => :current) { h(current_page) }

          if !last_page? && next_page
            higher = limit ? (next_page + limit) : page_count
            higher = [higher, page_count].min
            (next_page..higher).each do |n|
              out << link(n)
            end

            out << link(next_page, '>', :class => :next)
            out << link(page_count, 'Last', :class => :last)
          end

          out << '</div>'
          out.map{|e| e.to_s}.join("\n")
        end
        
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
