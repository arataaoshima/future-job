class BlogType < ApplicationRecord

  belongs_to :blog
  belongs_to :blog_category

end
