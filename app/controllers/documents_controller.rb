require 'doc_ripper'
require 'docx'

class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    @document = Document.new
  end

  def new
  end

  def create
    @document = current_user.documents.build(document_params)

    upload_file(params[:document][:doc_file])

    # parsing and updating content column
    file_text = File.open('public/memotravail.txt')
    @document.content = file_text.read
    respond_to do |format|
      if @document.save
        format.html { redirect_to document_path(@document), notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @document = Document.find(params[:id])
    @references = extracting_articles(@document)
    @paragraphs = display_docx(@document.doc_file_file_name)
  end

  private

  def document_params
    params.require(:document).permit([:doc_file])
  end

  def upload_file(uploaded_file)
    File.open(Rails.root.join('public', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end

  def doc_rip(file)
    DocRipper::rip("public/#{file}")
  end

  def extracting_articles(doc)
    matchdata = doc.content.scan(/(L\..[^a-z]*).+?(?=code)((code du travail|code de la santé publique))/i)
    references = []
    matchdata.each_with_index do |data, index|
      reference = {
      index: index + 1,
      num: data[0].strip,
      name: data[1].strip.capitalize
    }
    references << reference
    end
    return references
  end

  def display_docx(file)
    doc = Docx::Document.open("public/#{file}")
    return doc.paragraphs
  end
end
