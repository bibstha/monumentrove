# MonumenTrove

Organise your Monument pictures in the rails based Trove. Built as a demo for a company I was interviewed for.
This has been uploaded here because it contains quite a lot of test cases for reference pusposes. (Written in minispec, unit test, functional - controller tests, integration tests).

It uses the following features

* Devise for authentication
* Bootstrap for layout design
* Haml instead of erb
* Comprehensive tests: unit, functional and integration
* Paperclip for image uploads
* textacular for searching

## Requirements

* PostgreSQL (The search uses postgres VIEW for searching)

## Installation

```bash
git clone https://github.com/bibstha/monumentrove.git
cd monumentrove
bundle install
rake db:create db:migrate
rails s
```

You can also seed the initial database by a default user with

```bash
rake db:seed
```
