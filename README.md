Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates)

seed localhost DB

```
$ rake db:create
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U *USERNAME* -d lexyapp_development db/dump/20151215_lexyapp_development.dump
$ rake db:migrate
```
