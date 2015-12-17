Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates)

seed localhost DB

```
$ rake db:create
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U *USERNAME* -d lexyapp_development db/dump/20151215_lexyapp_development.dump
$ rake db:migrate
```

```
Regexp improvements
((L\.|R\.|D\.).[^a-z]*).+?(?=code)((code du travail|code de la santé publique))
chain_references = []
if reference[:num].include?("à")

  article_number = reference[:num].gsub(". ", "")
```
