require 'doc_ripper'
require 'docx'

class DocumentsController < ApplicationController
  def index
    @documents = Document.where(user_id: current_user.id)
  end

  def new
  end

  def create
    @document = current_user.documents.build(document_params)

    doc_file = upload_file(params[:document][:doc_file])

    @document.paragraphs = parse_doc_paragraphs(doc_file)

    File.delete(doc_file_path(doc_file))

    @references = extracting_articles(@document)
    @references.each do |reference|
      law_name = reference[:name].downcase
      law = Law.where(name: law_name).first
      article_number = reference[:num].gsub(". ", "")
      article = Article.where(law_id: law.id, number: article_number).first
      @reference = @document.references.build({article_id: article.id, paragraph_number: reference[:paragraph_number]})
      @reference.save
    end

    respond_to do |format|
      if @document.save
        format.html { redirect_to new_document_reference_path(@document), notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @document = Document.find(params[:id])
    references = Reference.where(document_id: @document.id)
  end

  private

  def document_params
    params.require(:document).permit([:doc_file, :name])
  end

  def upload_file(uploaded_file)
    File.open(doc_file_path(uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    uploaded_file.original_filename
  end

  def extracting_articles(doc)
    references = []
    doc.paragraphs.each_with_index do |paragraph, p_index|
      matchdata = paragraph.scan(/(L\..[^a-z]*).+?(?=code)((code du travail|code de la santé publique))/i)
      matchdata.each do |data|
        reference = {
        num: data[0].strip,
        name: data[1].strip.capitalize,
        paragraph_number: p_index
      }
      references << reference
      end
    end
    return references
  end

  def parse_doc_paragraphs(file)
    doc = Docx::Document.open(doc_file_path(file))
    return doc.paragraphs.map do |paragraph|
      paragraph.to_html.html_safe
    end
  end

  def doc_file_path(file)
    Rails.root.join('public', file)
  end
end
