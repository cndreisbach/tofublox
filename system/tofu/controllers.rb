require 'mime/types'

module Tofu::Controllers
  class StaticController < R('/(css/.+)')
    def get(file)
      if file.include? '..'
        @status = '403'
        return '403 - Invalid path'
      else
        type = (MIME::Types.type_for(file)[0] || 'text/plain').to_s
        @headers['Content-Type'] = type
        @headers['X-Sendfile'] = File.join Tofu.dir, 'public', file
      end
    end
  end
  
  class MoldListController < R '/molds'
    def get
      @molds = Mold.find(:all)
      render :mold_list, :app
    end
  end

  class MoldController < R '/molds/(\w+)'
    def get(id)
      @mold = Mold.find(id)
      render :mold, :app
    end
  end

  class BlockListController < R '/'
    def get
      @blocks = Block.find(:all, :order => 'desc')
      render :block_list, :app
    end

    # create a block
    def post
      @block = Block.new(Time.now.strftime("%Y%m%d%H%M%S"), input['block'].delete('type'), input['block'])
      @block.save
      redirect R(BlockListController)
    end
  end
end
