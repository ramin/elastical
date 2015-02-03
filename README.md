# Elastical

Elastic Search client for integration with Rails 4+.

Define indexes around multiple ActiveRecord models without adding index definitions into your models.

Allow models to exist in multiple indexes.

Supports scope based index inclusion critera.

## Installation

Add this line to your application's Gemfile:

    gem 'elastical'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elastical

### Usage

(Suggestion) Add the folder

```ruby
app/indexes
```

To your rails project to keep all elasticsearch indexes in one place and outside of your models. To generate a new index, run


```ruby

rails generate index SomeIndex

```

This will add the file

```ruby
app/indexes/some_index.rb
```

To the project which will look like

```ruby
class ContentIndex < Elastical::Base
end
```

Adding a model to the index is achieved through an indexes block, that takes an ActiveRecord scope as an argument, and defines the mappings and values for documents which will be indexed to elasticsearch inside the block with ```field``` declarations. Eg:

```ruby
class SomeIndex < Elastical::Base
  indexes Foo.where(live: true) do |foo|
    field :bar, type: 'string', store: true
  end
end
```

Fields can be aliased, should a field be needed to be indexed multiple times with different mappings

```ruby
field :bar, as: baz, type: 'string'
field :bar, as: baz_stemmed, type: 'string', analyzer: 'snowball'
```

Fields can also be arbitrarily created with their values as blocks

```ruby
field :not_a_db_field, boost: 1.5 do |foo_object|
  foo_object.title.downcase + " - adding something on"
end
```

It is common to index multiple Models in a single index, allowing you to avoid having your search index necessarily have to reflect your db schema and to mix variable types into a single common index if necessary to simplify querying, eg:

```ruby
class ContentIndex < Elastical::Base
  indexes Papers.where(liked: true) do |foo|
    field :abstract, boost: 2.3
  end

  indexes Books.where(read: true) do |foo|
    field :summary, analyzer: "snowball"
  end

  indexes Movies.where(watched: true) do |movie
    field :synopsis
  end
end
```

### building an index

```ruby

# Create or recreate the input and put mapping
SomeIndex.recreate!

# in batches of 100, index all docs
SomeIndex.in_batches

# Or if splitting work across n nodes
SomeIndex.segment(type: [model_type], segment: 1, segments: 10)
```

To find out details about the index

```
SomeIndex.mapping
SomeIndex.stats
```

On a model, you can find indexes it belongs to with

```ruby
SomeModel.indexes
```

And update or delete based on

```ruby
SomeModel.elastical_update!
SomeModel.elastical_remove!
```

To check is an ActiveRecord instance is within scope for a specific index, you can check

```ruby
SomeIndex.within_scope?(instance_of_model) # true or false
```

### test

``` rspec ```