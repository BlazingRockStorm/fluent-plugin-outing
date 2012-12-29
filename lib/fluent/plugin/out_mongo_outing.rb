require 'fluent/plugin/out_mongo_replset'

module Fluent
  Fluent::Plugin.register_output('mongo_outing', self)

  class MongoOutingOutput < MongoOutputReplset

    RE_STARTED =   /^Started (.+) "(.+)" for (.+) at /
    RE_SID =       /^  SID: "(.*)" UA: "(.*)" RF: "(.*)"/
    RE_COMPLETED = /^Completed (\d+) .* in (.+)ms \(Views: (.+)ms \| ActiveRecord: (.+)ms \| Solr: (.+)ms\)/

    def format(tag, time, record)
      record['messages'].each do |message|
        if RE_STARTED =~ message
          record['mt'] = $1
          record['pt'] = $2
          record['ip'] = $3
        elsif RE_SID =~ message
          record['sid'] = $1
          record['ua'] = $2
          record['rf'] = $3
        elsif RE_COMPLETED =~ message
          record['cd'] = $1
          record['tr'] = $2
          record['tv'] = $3
          record['ta'] = $4
          record['ts'] = $5
        end
      end
      [time, record].to_msgpack
    end
  end
end
