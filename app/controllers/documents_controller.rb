require 'doc_ripper'

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
    # parse .doc here
    respond_to do |format|
      if @document.save
        format.html { redirect_to root_path, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
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
    # memotravail = DocRipper::rip('xxx.docx')
    # p "-----------------------"
    # p "-----------------------"
    # p "-----------------------"
    # p memotravail.class

    # matchdata_codes = memotravail.scan(/(L\..[^a-z]*).+?(?=code)((code du travail|code de la sant))/i)
    # p matchdata_codes.size

    # # playing with the references

    # references = []
    # matchdata_codes.each_with_index do |data, index|
    #   reference = {
    #     index: index + 1,
    #     num: data[0].strip,
    #     name: data[1].strip.capitalize
    #   }
    #   references << reference
    # end

    # # cheating but working

    # references.each do |reference|
    #   ref_index = reference[:index]
    #   ref_num = reference[:num]
    #   ref_name = reference[:name]
    #   ref_name << "é publique" if reference[:name].include?("sant")
    #   p "#{ref_index} #{ref_num} #{ref_name}"
    # end
  end
end
