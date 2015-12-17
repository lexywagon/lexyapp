class FakeUpdateJob < ActiveJob::Base
  queue_as :default

  def perform
    dir = "demo"

    Dir.glob(File.join dir, "**/article/**/*.xml") do |article|
      doc = File.open(article) { |f| Nokogiri::XML(f) }

      law_cid = doc.xpath("//CONTEXTE/TEXTE/@cid").first.value
      law = Law.where(legi_cid: law_cid).first
      unless law
        law_name = doc.xpath("//CONTEXTE/TEXTE/TITRE_TXT/@c_titre_court").first.value.downcase
        law = Law.create({name: law_name, legi_cid: law_cid})
      end

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

          article.references.each do |ref|
            ref.status = "changed"
            ref.save
          end
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
  end
end


