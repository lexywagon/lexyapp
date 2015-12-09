class Article < ActiveRecord::Base
  belongs_to :law
  has_many :versions
end
