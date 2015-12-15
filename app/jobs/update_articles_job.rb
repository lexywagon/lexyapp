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

    # change path directory to get all laws
    Dir.glob(File.join dir, "legi/global/code_et_TNC_en_vigueur/code_en_vigueur/LEGI/TEXT/00/00/06/07/20/LEGITEXT000006072050/article/**/*.xml") do |article|
      # change code du travail with all laws
      code_du_travail = Law.first
      doc = File.open(article) { |f| Nokogiri::XML(f) }
      article_number = doc.xpath("//META_ARTICLE/NUM").first.content
      article = Article.where(number: article_number).first
      content = doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content
      if article
        if content != article.versions.last.content
          version =  article.versions.build({
            legi_id: doc.xpath("//META_COMMUN/ID").first.content,
            content: content,
            start_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_DEBUT").first.content),
            end_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_FIN").first.content),
            state: doc.xpath("//META_ARTICLE/ETAT").first.content
          })
          version.save
          # trigger TODO
          # article.references.each do |ref|
          #   ref.status = "pending"
          #   ref.save
          # end
        end
      else
        article = code_du_travail.articles.build({
          number: doc.xpath("//META_ARTICLE/NUM").first.content
        })
        article.save
        version =  article.versions.build({
          legi_id: doc.xpath("//META_COMMUN/ID").first.content,
          content: content,
          start_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_DEBUT").first.content),
          end_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_FIN").first.content),
          state: doc.xpath("//META_ARTICLE/ETAT").first.content
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


