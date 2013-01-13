require 'fluent/plugin/out_mongo_replset'

module Fluent

  class MongoOutingOutput < MongoOutputReplset

    Fluent::Plugin.register_output('mongo_outing', self)

    RE_STARTED =   /^Started (.+) "(.+)" for (.+) at /
    RE_SID =       /^  :SID "(.*)" :UID "(.*)" :UA "(.*)" :RF "(.*)"/
    RE_COMPLETED = /^Completed (\d+) .* in (.+)ms \(Views: (.+)ms \| ActiveRecord: (.+)ms \| Solr: (.+)ms\)/

    def format(tag, time, record)
      record['messages'].each do |message|
        if RE_STARTED =~ message
          record['mt'] = $1
          record['pt'] = $2
          record['ip'] = $3
        elsif RE_SID =~ message
          record['sid'] = $1
          record['uid'] = $2
          record['ua'] = $3
          record['rf'] = $4
        elsif RE_COMPLETED =~ message
          record['cd'] = $1
          record['tr'] = $2.to_f
          record['tv'] = $3.to_f
          record['ta'] = $4.to_f
          record['ts'] = $5.to_f
        end
      end
    rescue
    ensure
      super
    end
  end
end
