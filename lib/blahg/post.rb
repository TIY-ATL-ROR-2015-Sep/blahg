module Blahg
  class Post < ActiveRecord::Base
    has_many :post_tags
    has_many :tags, through: :post_tags

    def tag_names
      self.tags.map { |tag| tag.name }.join(", ")
    end
  end
end
