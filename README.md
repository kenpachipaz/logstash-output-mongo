# Logstash Mongo Plugin [![Gem Version](https://badge.fury.io/rb/logstash-output-mongo.svg)](https://badge.fury.io/rb/logstash-output-mongo)

## Changelog

See CHANGELOG.md

## Installation

- Run `bin/logstash-plugin install logstash-output-mongo` in your logstash installation directory

## Configuration options

| Option      | Type    | Description                                                                                                                                                                                    | Required?                | Default  |
|-------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|----------|
| database    | String  | The database to use.                                                                                                                                                                           | yes                      |          |
| collection  | String  | The collection to use. This value can use %{foo} values to dynamically select a collection based on data in the event.                                                                         | yes                      |          |
| uri         | String  | A MongoDB URI to connect to. See [Mongo Connection](http://docs.mongodb.org/manual/reference/connection-string/).                                                                              | yes                      |          |
| type        | String  | The operation to be executed. `[ insert, upsert, delete or update ]`.                                                                                                                          | no                       | insert   |
| attributes  | String  | List of attributes to build the `$set` statement.                                                                                                                                              | yes for update or upsert | []       |
| retry_delay | number  | The number of seconds to wait after failure before retrying.                                                                                                                                   | no                       | 3        |
| isodate     | boolean | If true, store the @timestamp field in MongoDB as an ISODate type instead of an ISO8601 string. For more information about this, see [Mongo Dates](http://www.mongodb.org/display/DOCS/Dates). | no                       | false    |

## Example configurations

```ruby
filter {
  mutate {
    add_field => { "_id" => "%{user_id}"}
  }
}
mongo {
    id => "mongo_db_output_id"
    database => "logstash-output-mongo"
    collection => "test"
    uri => "mongodb://127.0.0.1:27017/logstash-output-mongo"
    codec => "json"
    type => "upsert"
    attributes => ["name"]
}
```

## Need Help?

Need help? Feel free to contact me.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-filter-awesome", :path => "/your/local/logstash-filter-awesome"
```
- Install plugin
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Run Logstash with your plugin
```sh
bin/logstash -e 'filter {awesome {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-awesome.gemspec
```
- Install the plugin from the Logstash home
```sh
# Logstash 2.3 and higher
bin/logstash-plugin install --no-verify

# Prior to Logstash 2.3
bin/plugin install --no-verify

```
- Start Logstash and proceed to test the plugin

## Publish

```sh
# Build Gem 
gem build logstash-output-mongo.gemspec 

# Publish Gem
gem push logstash-output-mongo-1.0.1.gem
```

## Logstash Plugin

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.


## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.