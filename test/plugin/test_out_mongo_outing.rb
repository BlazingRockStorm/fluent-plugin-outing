# -*- coding: utf-8 -*-
require 'helper'

class MongoOutingOutputTest < Test::Unit::TestCase

  def test_format
    x = Fluent::MongoOutingOutput.new
    record = {
      'messages' => ["Started GET \"/facilities?word=%E5%B1%8B%E5%86%85%E6%96%BD%E8%A8%AD\" for 127.0.0.1 at 2012-12-23 17:21:15 +0900",
                 "Processing by FacilitiesController#index
as HTML",
                 "  Parameters: {\"word\"=>\"屋内施設\"}",
                 "  :SID \"376c8e11d46eb8fd4978e238c863a24e476dc007\" :UID \"user1\" :UA \"Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20100101 Firefox/10.0.11 Iceweasel/10.0.11\" :RF \"http://www.example.com/a.html\"",
                 "Completed 200 OK in 3922ms (Views: 1731.3ms | ActiveRecord: 441.4ms | Solr: 687.0ms)" ]
    }
    time, record = MessagePack.unpack(x.format(nil, nil, record))
    assert_equal 'GET', record['mt']
    assert_equal '/facilities?word=%E5%B1%8B%E5%86%85%E6%96%BD%E8%A8%AD', record['pt']
    assert_equal '127.0.0.1', record['ip']
    assert_equal '376c8e11d46eb8fd4978e238c863a24e476dc007', record['sid']
    assert_equal 'user1', record['uid']
    assert_equal 'Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20100101 Firefox/10.0.11 Iceweasel/10.0.11', record['ua']
    assert_equal 'http://www.example.com/a.html', record['rf']
    assert_equal '200', record['cd']
    assert_equal 3922, record['tr']
    assert_equal 1731.3, record['tv']
    assert_equal 441.4, record['ta']
    assert_equal 687.0, record['ts']
  end

  def test_format_invalid_byte_sequence
    x = Fluent::MongoOutingOutput.new
    record = {
      'messages' => ["Started GET \"/facilities?word=\xFF\" for 127.0.0.1 at 2012-12-23 17:21:15 +0900",
                 "Processing by FacilitiesController#index
as HTML",
                 "  Parameters: {\"word\"=>\"屋内施設\"}",
                 "  :SID \"376c8e11d46eb8fd4978e238c863a24e476dc007\" :UID \"user1\" :UA \"Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20100101 Firefox/10.0.11 Iceweasel/10.0.11\" :RF \"http://www.example.com/a.html\"",
                 "Completed 200 OK in 3922ms (Views: 1731.3ms | ActiveRecord: 441.4ms | Solr: 687.0ms)" ]
    }
    time, record = MessagePack.unpack(x.format(nil, nil, record))
    assert_equal 'GET', record['mt']
    assert_equal '/facilities?word=�', record['pt']
    assert_equal '127.0.0.1', record['ip']
    assert_equal '376c8e11d46eb8fd4978e238c863a24e476dc007', record['sid']
    assert_equal 'user1', record['uid']
    assert_equal 'Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20100101 Firefox/10.0.11 Iceweasel/10.0.11', record['ua']
    assert_equal 'http://www.example.com/a.html', record['rf']
    assert_equal '200', record['cd']
    assert_equal 3922, record['tr']
    assert_equal 1731.3, record['tv']
    assert_equal 441.4, record['ta']
    assert_equal 687.0, record['ts']
  end
end
