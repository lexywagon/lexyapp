class Document < ActiveRecord::Base
  belongs_to :user

  has_attached_file :doc_file
end
