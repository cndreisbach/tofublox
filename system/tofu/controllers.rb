class BlocksController < Ramaze::Controller
  map '/blocks'
  engine :Haml
  view_root Tofu.dir('system/templates/blocks')

  def get
    @blocks = Block.order(:created_at.desc)
  end

  def post
    @block = Block.new
    @block.mold = request.params['block'].delete('mold')

    request.params['block'].each do |key, value|
      @block.content[key] = value
    end

    @block.save
    redirect R('/')
  end
end


class MoldsController < Ramaze::Controller
  map '/molds'
  engine :Haml
  view_root Tofu.dir('system/templates/molds')
  
  def get
    @molds = Mold.find(:all)
  end
end


class MoldController < Ramaze::Controller
  map '/mold'
  engine :Haml
  view_root Tofu.dir('system/templates/mold')
  helper :form

  def get(id)
    @mold = Mold.find(id)
  end
end

# require 'mime/types'
# module Tofu::Controllers
#   class StaticController < R('/(css/.+)')
#     def get(file)
#       if file.include? '..'
#         @status = '403'
#         return '403 - Invalid path'
#       else
#         type = (MIME::Types.type_for(file)[0] || 'text/plain').to_s
#         @headers['Content-Type'] = type
#         @headers['X-Sendfile'] = File.join Tofu.dir, 'public', file
#       end
#     end
#   end  
# end
