# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "mongo"
require_relative "bson/big_decimal"
require_relative "bson/logstash_timestamp"

# This output writes events to MongoDB.
class LogStash::Outputs::Mongo < LogStash::Outputs::Base

  config_name "mongo"

  # A MongoDB URI to connect to.
  # See http://docs.mongodb.org/manual/reference/connection-string/.
  config :uri, :validate => :string, :required => true

  # The database to use.
  config :database, :validate => :string, :required => true

  # The collection to use. This value can use `%{foo}` values to dynamically
  # select a collection based on data in the event.
  config :collection, :validate => :string, :required => true

  # If true, store the @timestamp field in MongoDB as an ISODate type instead
  # of an ISO8601 string.  For more information about this, see
  # http://www.mongodb.org/display/DOCS/Dates.
  config :isodate, :validate => :boolean, :default => false

  # The number of seconds to wait after failure before retrying.
  config :retry_delay, :validate => :number, :default => 3, :required => false

  # Statement, define the statement to be run. Default `insert`
  config :type, :validate => :string, :default => "insert"

  # Statement, define the statement to be run. If is null insert_one
  config :attributes, :validate => :array, :default => []

  # Mutex used to synchronize access to 'documents'
  @@mutex = Mutex.new

  def register

    Mongo::Logger.logger = @logger
    conn = Mongo::Client.new(@uri)
    @db = conn.use(@database)

    @closed = Concurrent::AtomicBoolean.new(false)
  end

  def receive(event)
    begin
      # Our timestamp object now has a to_bson method, using it here
      # {}.merge(other) so we don't taint the event hash innards
      document = {}.merge(event.to_hash)

      @logger.info("Type=[#{@type}] Collection=[#{@collection}] _id=[#{document["_id"]}]")

      case @type

      when "upsert"
        statement = buildStatement(document)

        @db[event.sprintf(@collection)].update_one(
          { '_id' => document["_id"]},
          { '$set' => statement},
          :upsert => true
        )

      when "update"
        statement = buildStatement(document)

        @db[event.sprintf(@collection)].update_one(
          { '_id' => document["_id"]},
          { '$set' => statement}
        )

      when "insert"
        @db[event.sprintf(@collection)].insert_one(document)

      when "delete"
        @db[event.sprintf(@collection)].delete_one({ '_id' => document["_id"]})

      end

    rescue => e
      if e.message =~ /^E11000/
        # On a duplicate key error, skip the insert.
        # We could check if the duplicate key err is the _id key
        # and generate a new primary key.
        # If the duplicate key error is on another field, we have no way
        # to fix the issue.
        @logger.warn("Skipping insert because of a duplicate key error", :event => event, :exception => e)
      else
        @logger.warn("Failed to send event to MongoDB, retrying in #{@retry_delay.to_s} seconds", :event => event, :exception => e)
        sleep(@retry_delay)
        retry
      end
    end
  end

  def buildStatement(document)

    statement = {}

    @attributes.each do |attr|
      statement[attr] = document[attr]
    end

    return statement

  end

  def close
    @closed.make_true
  end
end
