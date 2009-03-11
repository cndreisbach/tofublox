Ramaze::Route['Tofu routing'] = lambda do |path, request|
  get_request_method = lambda do |request|
    method = if request.request_method == 'POST' and request.params.has_key?('method')
               request.params['method']
             else
               request.request_method
             end
    method.downcase
  end

  method = get_request_method[request]
  
  case path
  when '/admin' then "/blocks/get"
  when '/error' then '/error/500'
  when %r{/error/([\w\-]+)} then "/error/#{$1}"
  when '/molds' then "/molds/#{method}"
  when %r{/mold/(\w+)} then "/mold/#{method}/#{$1}"
  when '/blocks' then "/blocks/#{method}"
  when %r{/block/([\w\-]+)} then "/block/#{method}/#{$1}"
  when '/' then "/index/#{method}"
  when %r{/index/(\d+)} then "/index/#{method}/#{$1}"
  when %r{/view/([\w\-]+)} then "/view/#{method}/#{$1}"
  when %r{/logout/([\w\-]+)} then "/logout/#{method}/#{$1}"
  else "/error/404"
  end
end

Ramaze::Dispatcher::Error::HANDLE_ERROR.merge!({ 
  Tofu::Errors::Unauthorized => [ Ramaze::STATUS_CODE['Unauthorized'], '/error/401' ],
  Tofu::Errors::BadRequest => [ Ramaze::STATUS_CODE['Bad Request'], '/error/400' ],
  Tofu::Errors::NotFound => [ Ramaze::STATUS_CODE['Not Found'], '/error/404' ],
  Tofu::Errors::MethodNotAllowed => [ Ramaze::STATUS_CODE['Method Not Allowed'], '/error' ]
})
