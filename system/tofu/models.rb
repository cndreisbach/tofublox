require 'ostruct'

module Tofu::Models

  class Mold
    include ActiveFiles::Record

    attr_reader :fields, :template

    def initialize(fields = { }, template = "")
      @fields = fields
      @template = template
    end
    
    alias :name :file_id
    alias :to_s :file_id

    add_file_id_to_initialize

    def to_activefile
      { :fields => @fields,
        :template => @template }.to_yaml
    end

    def self.from_activefile(yaml, file_id)
      hash = YAML::load(yaml)
      Mold.new(file_id, hash[:fields], hash[:template])
    end

    def self.file_store
      File.join(ActiveFiles.base_dir, 'molds')
    end
  end

  class Block
    include ActiveFiles::Record
    
    attr_reader :mold, :content

    def initialize(mold_type, content = {})
      @mold = Mold.find(mold_type)
      @content = content
    end

    add_file_id_to_initialize

    def to_activefile
      @content.merge(:mold => @mold.name).to_yaml
    end

    def self.from_activefile(yaml, file_id)
      hash = YAML::load(yaml)
      mold_type = hash.delete(:mold)
      content = hash
      Block.new(file_id, mold_type, content)
    end

    def self.file_store
      File.join(ActiveFiles.base_dir, 'blocks')
    end

    def method_missing(method, *args)
      if @content.has_key?(method.to_s)
        @content[method.to_s]
      else
        raise NoMethodError
      end
    end
  end  
end
