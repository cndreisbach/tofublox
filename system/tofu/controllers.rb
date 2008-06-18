class TofuController < Ramaze::Controller
  engine :Ezamar
end


class AdminController < TofuController
  layout :layout

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

    request.params['block'].each do |key, value|
      block.content[key] = value
    end

    block.save
    redirect R('/')
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
