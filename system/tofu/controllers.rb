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
  helper :paginate
  
  trait :paginate => {
          :limit => Tofu.config.blocks_per_page || 1,
          :var => 'page'
        }
  
  def get(page = 1)
    @blocks = Block.where('published_at IS NOT NULL').order(:published_at.desc)
    @pager = paginate(@blocks, :page => page.to_i)
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

class LogoutController < TofuController
  map '/logout'

  include Tofu::Auth
  
  def get(old_username)
    unauthorized! if auth.username == old_username
    require_login
    redirect R(BlocksController)
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
    block.update_from_params(request.params['block'])
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
    @block.update_from_params(params)
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
