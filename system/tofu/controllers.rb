class TofuController < Ramaze::Controller
  engine :Ezamar
  layout :layout

  def layout
    render_template('../layouts/site')
  end
end


class AdminController < TofuController
  def layout
    render_template('../layouts/admin')
  end
end


class BlocksController < TofuController
  map '/blocks'

  def get
    @blocks = Block.order(:created_at.desc)
  end

  def post
    block = Block.new
    block.mold = request.params['block'].delete('mold')
    block.update_content(request.params['block'])

    block.save
    redirect R('/')
  end
end


class BlockController < TofuController
  map '/block'

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
  end

  def delete(permalink)
    @block = Block[:permalink => permalink]
    @block.destroy
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
