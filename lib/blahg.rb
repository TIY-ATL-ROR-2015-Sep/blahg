require "blahg/version"
require "blahg/init_db"

require "thor"
require "pry"

module Blahg
  class App < Thor
  end
end

# binding.pry
Blahg::App.start(ARGV)
