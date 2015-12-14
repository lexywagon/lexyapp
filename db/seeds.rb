require "nokogiri"

Dir.glob("db/legi/*/article/**/*.xml") do |article|
  doc = File.open(article) { |f| Nokogiri::XML(f) }

  law_cid = doc.xpath("//CONTEXTE/TEXTE/@cid").first.value
  law = Law.where(legi_cid: law_cid).first
  unless law
    law_name = doc.xpath("//CONTEXTE/TEXTE/TITRE_TXT/@c_titre_court").first.value.downcase
    law = Law.create({name: law_name, legi_cid: law_cid})
  end

  article_number = doc.xpath("//META_ARTICLE/NUM").first.content
  similar_article = Article.where(law_id: law.id, number: article_number).first
  if similar_article
    article = similar_article
  else
    article = law.articles.build({
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
