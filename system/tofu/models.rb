class Mold
  include ActiveFiles::Record

  attr_reader :fields, :summary, :body

  def initialize(fields, summary, body)
    @fields = fields
    @summary = summary
    @body = body
  end
  
  alias :name :file_id
  alias :to_s :file_id

  add_file_id_to_initialize
  
  def to_activefile
    raise RuntimeError, "Not implemented"
  end

  def self.from_activefile(yaml, file_id)
    documents = yaml.split("\n---\n")

    data = YAML::load(documents.shift)
    fields = data['Fields'].map { |field| field.to_a.first }
    summary = documents.shift || String.new
    body = documents.shift || summary
        
    Mold.new(file_id, fields, summary, body)
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
    string :author
    text :content
    timestamp :created_at
    timestamp :altered_at
  end

  validates do
    uniqueness_of :permalink
    presence_of :mold, :content, :author
  end

  validates_each :mold do |obj, attr, value|
    unless Tofu.molds.keys.include?(value.to_s)
      obj.errors[attr] = 'should be a valid mold'
    end
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

  def update_content(content)
    raise ArgumentError, "Content must be a hash" unless content.is_a? Hash
    content.each do |key, value|
      self.content[key] = value
    end
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

  def summary
    Ezamar::Template.new(self.mold.summary, :file => mold.send(:filename) ).result(binding)
  end

  def body
    Ezamar::Template.new(self.mold.body, :file => mold.send(:filename) ).result(binding)
  end

  alias_method :to_s, :body
  alias_method :to_str, :body

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
