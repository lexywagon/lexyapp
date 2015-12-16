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
end
