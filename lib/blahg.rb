require "blahg/version"
require "blahg/init_db"

require "blahg/post"
require "blahg/tag"
require "blahg/post_tag"
require "blahg/importer"

require "date"
require "thor"
require "pry"

## Subcommands to add?
#
#  * Show a given page of posts.
#  * Add a new post. (DONE)
#  * Edit post tags.
#  * Find posts in a given month.
#  * Show top tags used, months posted in, etc.
#  * Find posts by tag.
#  * Delete posts by tag.

module Blahg
  class App < Thor

    desc "add NAME", "Add a post to the database."
    option :date, :aliases => :d, :default => DateTime.now.to_s
    option :tags, :aliases => :t, :type => :array
    option :format, :aliases => :f, :default => "cmdline"
    def add(name)
      puts "Creating blog post #{name}"
      puts "What is the content of the blog post?"
      content = STDIN.gets.chomp
      post = Post.create(title: name,
                         date: options[:date],
                         format: options[:format],
                         content: content)
      puts "Created new post: #{post}"
    end

    desc "show", "Show a page of blog posts."
    option :page, :aliases => :p, :default => 1, :type => :numeric
    def show
      puts "Page #{options[:page]} of this blaaaaahg."
      start = options[:page] * 10
      posts = Post.offset(start).limit(10)
      posts.each do |post|
        puts "Title: #{post.title}, Written: #{post.date}, Tags: #{post.tag_names}"
      end
    end

    desc "import DIRECTORY", "Import all blog posts from DIRECTORY."
    def import(directory)
      importer = Importer.new(directory)
      posts = importer.get_posts

      posts.each do |post|
        puts "Importing post: #{post[:title]}"
        tag_models = post[:tags].map { |tag| Tag.find_or_create_by(name: tag) }
        post[:tags] = tag_models
        post_model = Post.create(post)
        puts "New post! #{post_model}"
      end

      puts "#{posts.count} posts imported!"
    end

  end
end

# binding.pry
Blahg::App.start(ARGV)
