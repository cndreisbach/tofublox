class Block < Sequel::Model
  Block.plugin(:schema)
  Block.plugin(:validation_class_methods)
  Block.plugin(:hook_class_methods)
  
  set_schema do
    primary_key :id
    string :permalink
    string :mold
    string :author
    text :content
    timestamp :created_at
    timestamp :altered_at
    timestamp :published_at
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

  after_initialize :setup_content
  before_save :set_permalink
  before_save(:set_timestamps) do
    now = Time.now
    self.created_at ||= now
    self.altered_at = now
  end

  def self.all_values
    self.all.map { |b| b.values.reject { |k, v| k == :id } }
  end

  def content=(new_content)
    raise ArgumentError, "Content must be a hash" unless new_content.is_a? Hash
    @values[:content] = new_content
  end

  def update_content(new_content)
    raise ArgumentError, "Content must be a hash" unless new_content.is_a? Hash
    new_content.each do |key, value|
      self.content[key] = value
    end
  end

  def raw_field(key)
    content[key.to_s]
  end
  
  def field(key)
    key = key.to_s
    formatter = mold.formatters[key]
    begin
      formatter.new(raw_field(key)).to_html
    rescue NameError
      raw_field(key)
    end
  end
  
  alias :f :field

  def title
    key = %w(title Title).detect { |t| !content[t].nil? }
    content[key]
  end

  def mold
    Tofu.molds[@values[:mold]]
  end

  def summary
    Ezamar::Template.new(self.mold.summary, :file => mold.send(:filename) ).result(binding)
  end

  def body
    Ezamar::Template.new(self.mold.body, :file => mold.send(:filename) ).result(binding)
  end
  
  def published?
    !self.published_at.nil?
  end
  
  def published=(bool)
    if bool and !published?
      self.published_at = Time.now
    elsif !bool
      self.published_at = nil
    end
  end

  alias :to_s :body
  alias :to_str :body

  private

  def setup_content
    self.content = Hash.new unless self.content.is_a? Hash
  end

  def set_permalink
    if permalink.blank?
      if title
        permalink = title.slugify[0..50]
      else
        permalink = Time.now.strftime("%Y%m%d%H%M")
      end
      self.permalink = make_unique(permalink)    
    end
  end
  
  def make_unique(permalink)
    block = Block[:permalink => permalink]

    if block.nil? or block.id == self.id
      permalink
    else
      permalink.gsub(/\-\d\d+$/, '')
      permalink += "-#{Time.now.strftime("%S")}"
      make_unique(permalink)
    end
  end
end
