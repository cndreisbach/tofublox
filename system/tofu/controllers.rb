class TofuController < Ramaze::Controller
  engine :Ezamar
  layout :layout

  def layout
    render_template('../layouts/site')
  end

  %w(get post put delete).each do |action|
    define_method(action) do
      raise Tofu::Errors::MethodNotAllowed
    end
  end
  
  private

  def load_block(permalink)
    @block = Block[:permalink => permalink]
    raise Tofu::Errors::NotFound if @block.nil?
  end
end

class IndexController < TofuController
  map '/index'
  helper :formatting
  
  def get
    @blocks = Block.where('published_at IS NOT NULL').order(:published_at.desc)
  end
end


class ViewController < TofuController
  map '/view'
  helper :formatting

  def get(permalink)
    load_block(permalink)
  end
end


class AdminController < TofuController
  include Tofu::Auth
  helper :aspect

  before(:get, :post, :put, :delete) { require_login }

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
    @block = Block.new(:mold => @mold)
  end
end

class BlocksController < AdminController
  map '/blocks'

  def get
    @blocks = Block.order(:altered_at.desc)
  end

  def post
    block = Block.new
    block.mold = request.params['block'].delete('mold')
    block.author = request.params['block'].delete('author')
    block.published = (request.params['block'].delete('published') == 'true')
    block.update_content(request.params['block'])

    block.save

    redirect R(BlocksController)
  end
end


class BlockController < AdminController
  map '/block'
  helper :form

  def get(permalink)
    load_block(permalink)
  end
  
  def put(permalink)
    load_block(permalink)
    params = request.params['block'].dup

    @block.mold = params.delete('mold') if params['mold']
    @block.author = params.delete('author') if params['author']
    @block.published = (request.params['block'].delete('published') == 'true')

    @block.update_content(params)
    @block.save
    
    redirect R(BlocksController)
  end

  def delete(permalink)
    load_block(permalink)
    @block.destroy
    redirect R(BlocksController)
  end

end

class ErrorController < TofuController
  map '/error'

  define_method('401') { }
  define_method('404') { }
  define_method('500') { }

  def method_missing(sym)
    self.send('500')
  end
end
