require "blahg/version"
require "blahg/init_db"

require "blahg/post"
require "blahg/tag"
require "blahg/post_tag"
require "blahg/importer"

require "thor"
require "pry"

module Blahg
  class App < Thor

    desc "import DIRECTORY", "Import all blog posts from DIRECTORY."
    def import(directory)
      importer = Importer.new(directory)
      posts = importer.get_posts
      posts.each do |post|
        puts "Importing post: #{post[:title]}"
        tag_models = post[:tags].map { |tag| Tag.find_or_create_by(name: tag) }
        post[:tags] = tag_models
        Post.create(post)
        puts "New post! #{post_model}"
      end
      puts "#{posts.count} posts imported!"
    end
  end
end

# binding.pry
Blahg::App.start(ARGV)
