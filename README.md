Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates)

seed DB with "code du travail"

```
$ rake db:create
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U *USERNAME* -d lexyapp_development 20151215_lexyapp_development.dump
```
