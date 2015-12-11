require "nokogiri"

code_du_travail = Law.create({name: "code du travail", legi_cid: "LEGITEXT000006072050"})

Dir.glob("db/LEGITEXT000006072050/article/**/*.xml") do |article|
  doc = File.open(article) { |f| Nokogiri::XML(f) }
  article_number = doc.xpath("//META_ARTICLE/NUM").first.content
  similar_article = Article.where(number: article_number).first
  if similar_article
    article = similar_article
  else
    article = code_du_travail.articles.build({
      number: article_number
    })
    article.save
  end
  version = article.versions.build({
    legi_id: doc.xpath("//META_COMMUN/ID").first.content,
    content: doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content,
    start_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_DEBUT").first.content),
    end_date: Date.parse(doc.xpath("//META_ARTICLE/DATE_FIN").first.content),
    state: doc.xpath("//META_ARTICLE/ETAT").first.content
  })
  version.save
end
