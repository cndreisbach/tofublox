unless defined? ERB
  begin
    require 'erubis'
    ERB = Erubis::Eruby
  rescue MissingSourceFile
    require 'erb'
  end
end

module Tofu::Helpers
  include Tofu::Controllers
  
  def form_field(datatype, options)
    case datatype
    when 'text' then textarea(:name => options[:name]) { options[:value] }
    else input options.merge(:type => 'text')
    end
  end

  def render_layout(layout, content)
    ERB.new(IO.read("#{Tofu.dir}/templates/layouts/#{layout}.html.erb")).result(binding)
  end

  def render_block(block)
    content = ERB.new(block.mold.template).result(binding)
    return content
  end

  def render(file, layout = nil)
    content = ERB.new(IO.read("#{Tofu.dir}/templates/#{file}.html.erb")).result(binding)
    content = render_layout(layout, content) if layout
    return content
  end
end
