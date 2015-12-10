require 'net/ftp'
require 'rubygems/package'
require 'zlib'
require 'fileutils'

class UpdateArticlesJob < ActiveJob::Base
  queue_as :default

  def perform
    ftp = Net::FTP.new('ftp2.journal-officiel.gouv.fr')
    ftp.login('legi', 'open1234')
    file = ftp.nlst.last
    ftp.get(file)
    unzip(file)
    File.delete(file)
    dir = file.gsub("legi_", "").gsub(".tar.gz", "")

    Dir.glob(File.join dir, "legi/global/code_et_TNC_en_vigueur/code_en_vigueur/LEGI/TEXT/00/00/06/07/20/LEGITEXT000006072050/article/**/*.xml") do |article|
      code_du_travail = Law.first
      doc = File.open(article) { |f| Nokogiri::XML(f) }
      article_id = doc.xpath("//ID").first.content
      article = Article.where(legi_id: article_id).first
      content = doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content
      if article
        if content != article.versions.last.content
          version =  article.versions.build({
            content: content
          })
          version.save
        end
      else
        article = code_du_travail.articles.build({
          number: doc.xpath("//NUM").first.content,
          legi_id: doc.xpath("//ID").first.content
        })
        article.save
        version =  article.versions.build({
          content: content
        })
        version.save
      end

    end
    FileUtils.rm_rf(dir)
  end

  def unzip(tar_gz_archive, destination = ".")
    Gem::Package::TarReader.new( Zlib::GzipReader.open tar_gz_archive ) do |tar|
      dest = nil
      tar.each do |entry|
        if entry.full_name == '././@LongLink'
          dest = File.join destination, entry.read.strip
          next
        end
        dest ||= File.join destination, entry.full_name
        if entry.directory?
          File.delete dest if File.file? dest
          FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
        elsif entry.file?
          FileUtils.rm_rf dest if File.directory? dest
          File.open dest, "wb" do |f|
            f.print entry.read
          end
          FileUtils.chmod entry.header.mode, dest, :verbose => false
        elsif entry.header.typeflag == '2' #Symlink!
          File.symlink entry.header.linkname, dest
        end
        dest = nil
      end
    end
  end
end


