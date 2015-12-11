class Document < ActiveRecord::Base
  belongs_to :user

  has_attached_file :doc_file
  validates_attachment_content_type :doc_file,
    content_type: ["application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/msword"]
end
