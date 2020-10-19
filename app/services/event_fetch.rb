module EventFetch

  def self.get_one_event(id)
    HTTParty.get("#{API_URL}/activities/#{id}", :headers => { "Api-Key" => API_KEY })
  end

  def self.get_events
    response = { "last_page" => false }
    all_activities = []
    page = 0
    until response["last_page"] == true do
      page += 1
      response = HTTParty.get("#{API_URL}/events?page=#{page}", :headers => { "Api-Key" => API_KEY })
      activities = response["activities"] || []
      activities.each do |activity|
        activity["type"] = "activity"
        activity["start"] = Time.at(activity["start_time"])
        all_activities << activity
      end
      series = response["series"] || []
      series.each do |ser|
        ser["type"] = "session"
        ser["sessions"].each do |ses|
          ses["type"] = "series session"
          ses["start"] = Time.at(ses["start_time"])
          all_activities << ses
        end
      end
    end
    all_activities.delete_if { |ses| ses["start"] > Time.now }.sort_by! { |h| h["start"] }.reverse!
    all_activities[0..29]
  end
end
