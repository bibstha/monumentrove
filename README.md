# MonumenTrove

Organise your Monument pictures in the rails based Trove.

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