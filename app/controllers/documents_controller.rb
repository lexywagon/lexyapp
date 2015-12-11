require 'doc_ripper'

class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    s3 = Aws::S3::Client.new(region:'eu-west-1')
    File.open('xxxxxxx', 'wb') do |file|
      reap = s3.get_object({ bucket:'lexybucket', key:'development/documents/texts/000/000/009/original/memotravail_-_copie.docx' }, target: file)
    end
    memotravail = DocRipper::rip('xxxxxxx')
    p memotravail
  end

  def new
  end

  def create
  end
end
