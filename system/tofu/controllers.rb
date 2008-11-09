class TofuController < Ramaze::Controller
  engine :Ezamar
  layout :layout

  def layout
    render_template('../layouts/site')
  end
end

class IndexController < TofuController
  map '/index'

  def get
    @blocks = Block.order(:created_at.desc)
  end
end


class ViewController < TofuController
  map '/view'

  def get(permalink)
    @block = Block[:permalink => permalink]
    if @block.nil?
      respond("That block was not found.", 404)
    end
  end
end


class AdminController < TofuController
  include Tofu::Auth
  helper :aspect

  before(:get, :post) { require_login }

  def layout
    render_template('../layouts/admin')
  end
end


class MoldsController < AdminController
  map '/molds'
  
  def get
    @molds = Mold.find(:all)
  end
end


class MoldController < AdminController
  map '/mold'
  helper :form

  def get(id)
    @mold = Mold.find(id)
  end
end

class BlocksController < AdminController
  map '/blocks'

  def get
    @blocks = Block.order(:created_at.desc)
  end

  def post
    block = Block.new
    block.mold = request.params['block'].delete('mold')
    block.update_content(request.params['block'])

    block.save

    redirect R(BlocksController)
  end
end


class BlockController < AdminController
  map '/block'
  helper :form

  def get(permalink)
    @block = Block[:permalink => permalink]
    if @block.nil?
      respond("That block was not found.", 404)
    end
  end
  
  def put(permalink)
    @block = Block[:permalink => permalink]

    if request.params['block']['mold']
      @block.mold = request.params['block'].delete('mold')
    end

    @block.update_content(request.params['block'])
    @block.save
    
    redirect R(BlocksController)
  end

  def delete(permalink)
    @block = Block[:permalink => permalink]
    @block.destroy

    redirect R(BlocksController)
  end
end

class ErrorController < TofuController
  map '/error'

  define_method(:401) { }
  define_method(:404) { }
  define_method(:500) { }

  def method_missing(sym)
    self.send(:500)
  end
end
