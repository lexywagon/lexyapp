```
Rails ap with LeWagon templates
Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates)
```

seed localhost DB

```
Database
$ rake db:create
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U *USERNAME* -d lexyapp_development db/dump/20151215_lexyapp_development.dump
$ rake db:migrate
```

```
Deploy on Heroku:
1. Be sure branch master is up-to-date with GitHub: $ gst, $ git pull origin master
2. Make sure Heroku accounts exists: $ git remote -v, otherwise, create a Heroku repo
3. Push the master branch on heroku: $ git push heroku master
4. If changes have been made to the database (new tables, new columns, etc.): $ heroku run rake db:migrate
```
