class Object
  def blank?
    nil? || (respond_to?(:empty?) && empty?)
  end
end

class String
  def slugify
    self.strip.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-')
  end
  
  def camelize
    str = self.clone
    str.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end
  
  def constantize
    names = self.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end