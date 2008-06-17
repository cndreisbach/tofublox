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
    documents = yaml.split("\n---\n")
    fields = YAML::load documents.shift
    template = documents.shift || String.new
        
    Mold.new(file_id, fields, template)
  end

  def self.file_store
    File.join(Tofu.dir, 'molds')
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

  after_initialize(:setup_content) do
    self.content = Hash.new unless self.content.is_a? Hash
  end

  before_save(:set_timestamps) do
    now = Time.now
    self.created_at ||= now
    self.altered_at = now
  end

  def content=(content)
    raise ArgumentError, "Content must be a hash" unless content.is_a? Hash
    @values[:content] = content
  end

  def mold
    Tofu.molds[@values[:mold]]
  end

  def field(key)
    @values[:content][key]
  end

  alias f field

  def to_html
    Ezamar::Template.new(self.mold.template).result(binding)
  end
end
