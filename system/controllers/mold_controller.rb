class MoldController < Ramaze::Controller
  map '/molds'

  def index(id)
    send(request.request_method.downcase, id)
  rescue NoMethodError
    "bad request"
  end

  private
  
  def get(id)
    @mold = Mold.find(id)
  end
end
