# require "nokogiri"

# code_du_travail = Law.create({name: "code du travail", legi_cid: "LEGITEXT000006072050"})

# Dir.glob("db/LEGITEXT000006072050/article/**/*.xml") do |article|
#   doc = File.open(article) { |f| Nokogiri::XML(f) }
#   article = code_du_travail.articles.build({
#     number: doc.xpath("//NUM").first.content,
#     legi_id: doc.xpath("//ID").first.content
#   })
#   article.save
#   version = article.versions.build({
#     content: doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content
#   })
#   version.save
# end


require "nokogiri"

code_du_travail = Law.first

Dir.glob("legi/global/code_et_TNC_en_vigueur/code_en_vigueur/LEGI/TEXT/00/00/06/07/20/LEGITEXT000006072050/article/**/*.xml") do |article|
  doc = File.open(article) { |f| Nokogiri::XML(f) }
  article_id = doc.xpath("//ID").first.content
  article = Article.where(legi_id: article_id).first
  unless article
    article = code_du_travail.articles.build({
      number: doc.xpath("//NUM").first.content,
      legi_id: doc.xpath("//ID").first.content
    })
    article.save
  end

  content = doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content
  if content != article.versions.last.content
    p article_id
    version =  article.versions.build({
      content: content
    })
    version.save
  end

end
