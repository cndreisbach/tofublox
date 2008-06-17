$:.push(File.dirname(__FILE__) + '/system')
require 'tofu'

Ramaze.trait[:essentials].delete Ramaze::Adapter
Ramaze.start!
run Ramaze::Adapter::Base
