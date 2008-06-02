unless defined? ERB
  begin
    require 'erubis'
    ERB = Erubis::Eruby
  rescue
    require 'erb'
  end
end

module Tofu::Helpers
  def form_field(datatype, options)
    case datatype
    when 'text':
        textarea(:name => options[:name]) { options[:value] }
    else
      input options.merge(:type => 'text')
    end
  end
end
