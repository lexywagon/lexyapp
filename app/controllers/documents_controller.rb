require 'doc_ripper'

class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    s3 = Aws::S3::Client.new(region:'eu-west-1')
    File.open('xxx.docx', 'wb') do |file|
      reap = s3.get_object({ bucket:'lexybucket', key:'development/documents/texts/000/000/009/original/memotravail_-_copie.docx' }, target: file)
    end
    memotravail = DocRipper::rip('xxx.docx')
    p "-----------------------"
    p "-----------------------"
    p "-----------------------"
    p memotravail.class

    matchdata_codes = memotravail.scan(/(L\..[^a-z]*).+?(?=code)((code du travail|code de la sant))/i)
    p matchdata_codes.size

    # playing with the references

    references = []
    matchdata_codes.each_with_index do |data, index|
      reference = {
        index: index + 1,
        num: data[0].strip,
        name: data[1].strip.capitalize
      }
      references << reference
    end

    # cheating but working

    references.each do |reference|
      ref_index = reference[:index]
      ref_num = reference[:num]
      ref_name = reference[:name]
      ref_name << "é publique" if reference[:name].include?("sant")
      p "#{ref_index} #{ref_num} #{ref_name}"
    end

  end

  def new
  end

  def create
  end
end
