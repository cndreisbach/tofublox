class Block < Sequel::Model
  set_schema do
    primary_key :id
    string :mold
    text :content
    timestamp :created_at
    timestamp :posted_at
    boolean :in_timeline
    boolean :visible
  end

  serialize :content
  sti_key :mold

  after_initialize(:setup_content) do
    self.content = Hash.new unless self.content.is_a? Hash
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
end
