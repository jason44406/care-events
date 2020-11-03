class EventFetchTest < ActiveSupport::TestCase

  def setup
    @event_index_body =
      {'page':1,'total':1,'last_page':false,'series':
        ['id':1,'sessions':[
          {'id':1,'start_time': 1.week.ago.to_i },
          {'id':2,'start_time': 1.day.ago.to_i } ]
        ]
      }.to_json

      @event_index_body_last_page =
      {'page':2,'total':1,'last_page':true,'activities':
        [
          {'id':3,'start_time': 1.hour.ago.to_i },
          {'id':4,'start_time': 1.hour.since.to_i },
          {'id':5,'start_time': 1.day.since.to_i }
        ]
      }.to_json

    stub_request(:get, "#{API_URL}/events?page=1").to_return(status: 200, headers: {"Content-Type"=> "application/json"}, body: @event_index_body)
    stub_request(:get, "#{API_URL}/events?page=2").to_return(status: 200, headers: {"Content-Type"=> "application/json"}, body: @event_index_body_last_page)
    @response = EventFetch.get_events
  end

  test "fetches and removes dates > today " do
    assert_equal 3, @response.size
  end

  test "fetches and reverse orders remaining by date" do
    assert_equal [3,2,1], @response.map{ |i| i["id"] }
  end

  test "get activity detail" do
    stub_request(:get, "#{API_URL}/activities/1").to_return(status: 200, headers: {"Content-Type"=> "application/json"}, body: '')
    response = EventFetch.get_one_event(1)
    assert_equal 200, response.code
  end

end
