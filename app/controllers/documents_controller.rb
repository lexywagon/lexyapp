require 'doc_ripper'
require "pathname"

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
    doc_rip(@document.doc_file_file_name)
    file_text = File.open('public/memotravail.txt')
    @document.content = file_text.read

    @references = extracting_articles(@document)
    @references.each do |reference|
      law_name = reference[:name].downcase
      law = Law.where(name: law_name).first
      article_number = reference[:num].gsub(". ", "")
      article = Article.where(law_id: law.id, number: article_number).first
      @reference = @document.references.build({article_id: article.id})
      @reference.save
    end

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

  def display_doc_nicely(text)
  end

end
