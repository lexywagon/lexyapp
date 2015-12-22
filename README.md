```
Rails ap with LeWagon templates
Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates)
```

```
seed localhost DB
seed file instructions in seeds.rb to populate database with new laws and new codes
```

```
Database refaire db
$ rake db:create
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U *USERNAME* -d lexyapp_development db/dump/20151215_lexyapp_development.dump
$ rake db:migrate
```

```
Do fake testing
1. Upload manually "fake" database on AWS
local_path = lexyapp_development app/assets/dump/20151215_lexyapp_development.dump
2. Push db sur Heroku from AWS url
$ heroku pg:backups restore 'https://s3-eu-west-1.amazonaws.com/lexybucket/20151215_lexyapp_development.dump' DATABASE_URL
3. Rake db:migrate
$ heroku run rake db:migrate
4. fake updates test : Fake legi
$ heroku run rake legi:fake
5. real updates test
$ heroku run rake legi:update
More infos on: https://devcenter.heroku.com/articles/heroku-postgres-import-export
```


```
Deploy on Heroku:
1. Be sure branch master is up-to-date with GitHub: $ gst, $ git pull origin master
2. Make sure Heroku accounts exists: $ git remote -v, otherwise, create a Heroku repo
3. Push the master branch on heroku: $ git push heroku master
4. If changes have been made to the database (new tables, new columns, etc.): $ heroku run rake db:migrate
```
