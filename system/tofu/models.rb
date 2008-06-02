module Tofu::Models
  class Block < Base
    attr_accessor :content
    serialize :content

    def content
      write_attribute(:content, Hash.new) if read_attribute(:content).nil?
      read_attribute(:content)
    end
  end
  
  class InitialDB < V 1.0
    def self.up
      create_table :tofu_blocks do |t|
        t.text :content, :null => false
        t.string :type, :null => false
        t.timestamps
      end
    end
  end
end
