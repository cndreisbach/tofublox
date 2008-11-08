Ramaze::Route['Tofu routing'] = lambda do |path, request|
  def self.get_request_method(request)
    method = if request.request_method == 'POST' and request.params.has_key?('method')
               request.params['method']
             else
               request.request_method
             end
    method.downcase
  end

  method = self.get_request_method(request)
  
  case path
  when '/error' then "/error/#{method}"
  when '/molds' then "/molds/#{method}"
  when %r{/mold/(\w+)} then "/mold/#{method}/#{$1}"
  when '/blocks' then "/blocks/#{method}"
  when %r{/block/([\w\-]+)} then "/block/#{method}/#{$1}"
  when '/' then "/index/#{method}"
  when %r{/view/([\w\-]+)} then "/view/#{method}/#{$1}"
  else "/error/#{method}"
  end
end
