require 'mime/types'

module Tofu::Controllers
  class Static < R('/(css/.+)')
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
