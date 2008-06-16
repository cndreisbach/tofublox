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
    File.join(Tofu.dir, 'molds')
  end

  def create_block
    eval("class ::#{self.name} < Block
            #{create_block_fields}
          end")
  end

  private

  def create_block_fields
    self.fields.map { |field, definition| create_block_field(field) }.join("\n")
  end

  def create_block_field(field)
    "def #{field}; self.content['#{field}']; end\n" +
      "def #{field}=(data); self.content['#{field}'] = data; end"
  end
end


class Block < Sequel::Model
  set_schema do
    primary_key :id
    string :mold
    text :content
    timestamp :created_at
    timestamp :altered_at
  end

  serialize :content
  sti_key :mold

  after_initialize(:setup_content) do
    self.content = Hash.new unless self.content.is_a? Hash
  end

  before_save(:set_timestamps) do
    self.created_at ||= Time.now
    self.altered_at = Time.now
  end

  def initialize(*args)
    super(*args)
  end

  def content=(content)
    @values[:content] = content
  end

  def mold
    Tofu.molds[@values[:mold]]
  end

  def to_html
    ERB.new(self.mold.template).result(binding)
  end
end
