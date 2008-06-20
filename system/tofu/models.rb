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
    raise RuntimeError, "Not implemented"
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
    string :permalink
    string :mold
    text :content
    timestamp :created_at
    timestamp :altered_at
  end

  validates do
    uniqueness_of :permalink
  end

  serialize :content

  after_initialize(:setup_content) do
    self.content = Hash.new unless self.content.is_a? Hash
  end

  before_save(:set_permalink) do
    set_permalink if self.permalink.nil? or self.permalink.empty?
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

  def field(key)
    @values[:content][key.to_s]
  end

  def title
    key = %w(title Title).detect { |t| !@values[:content][t].nil? }
    @values[:content][key]
  end

  alias f field

  def mold
    Tofu.molds[@values[:mold]]
  end

  def to_s
    Ezamar::Template.new(self.mold.template).result(binding)
  end

  alias to_str to_s

  private

  def set_permalink
    if self.title
      self.permalink = title.slugify[0..50]
    else
      self.permalink = Time.now.strftime("%Y%m%d%H%M")
    end

    make_unique = lambda do |permalink|
      block = Block[:permalink => permalink]
      
      if block.nil? or block.id == self.id
        permalink
      else
        permalink.gsub(/\-\d\d+$/, '')
        permalink += "-#{Time.now.strftime("%S")}"
        make_unique.call(permalink)
      end
    end

    self.permalink = make_unique.call(permalink)    
  end
end
