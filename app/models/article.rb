class Article < ActiveRecord::Base
  belongs_to :law
  has_many :versions
  has_many :references
  has_many :documents, through: :references
end
