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
    [@fields.to_yaml, @template].join("--- \n")
  end

  def self.from_activefile(yaml, file_id)
    fields, template = nil
    
    YAML::load_documents(yaml) do |document|
      if fields.nil?
        fields = document
      elsif template.nil?
        template = document
      else
        break
      end
    end
      
    Mold.new(file_id, fields, template)
  end

  def self.file_store
    File.join(ActiveFiles.base_dir, 'molds')
  end
end
