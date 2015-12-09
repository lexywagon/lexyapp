# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "nokogiri"

code_du_travail = Law.create({name: "code du travail", legi_cid: "LEGITEXT000006072050"})

Dir.glob("db/LEGITEXT000006072050/article/**/*.xml") do |article|
  doc = File.open(article) { |f| Nokogiri::XML(f) }
  article = code_du_travail.articles.build({
    number: doc.xpath("//NUM").first.content,
    legi_id: doc.xpath("//ID").first.content
  })
  article.save
  version = article.versions.build({
    content: doc.xpath("//BLOC_TEXTUEL/CONTENU").first.content
  })
  version.save
end
