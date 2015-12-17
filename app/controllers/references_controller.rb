class ReferencesController < ApplicationController
  def new
    @document = Document.find(params[:document_id])
    @paragraphs = @document.paragraphs.map.with_index do |paragraph, index|
      {
        content: paragraph,
        references: Reference.where(document_id: @document.id, paragraph_number: index)
      }
    end
  end

  def create
    @document = Document.find(params[:document_id])
    @document.name = params[:document][:name]
    @document.save

    params[:references].each do |key, value|
      ref = Reference.find(key)
      ref.tracking = value[:tracking]
      ref.save
    end
    redirect_to documents_path
  end
end
