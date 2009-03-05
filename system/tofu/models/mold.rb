class Mold
  include ActiveFiles::Record

  attr_reader :fields, :formatters, :summary, :body

  def initialize(fields, summary, body)
    @fields = fields
    @summary = summary
    @body = body

    load_formatters
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

  private

  def load_formatters
    @formatters = {}

    @fields.each do |field|
      name, type = *field
      klass = begin
        "Tofu::Formatters::#{type.camelize}".constantize
      rescue NameError
        Tofu::Formatters::String
      end
      @formatters[name] = klass
    end
  end
end
