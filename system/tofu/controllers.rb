module Tofu::Controllers
  class MoldList < R '/molds'
    def get
      @molds = Tofu.mold_names
      render :mold_list, :app
    end
  end

  class Mold < R '/molds/(\w+)'
    def get(id)
      @name = id
      @mold = Tofu.molds[id]
      render :mold, :app
    end
  end

  class BlockList < R '/'
    def get
      @blocks = Block.find(:all, :order => 'created_at DESC')
      render :block_list, :app
    end

    # create a block
    def post
      @block = "Tofu::Models::#{input['block']['type']}".constantize.new
      input['block'].each do |key, value|
        @block.send("#{key}=", value)
      end
      @block.save
    end
  end
end
