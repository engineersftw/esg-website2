require 'faraday'

class WebuildsgEventsService
  def scrape
    events_url = ENV['WEBUILDSG_EVENT_URL'] || 'https://webuild.sg/api/v1/events'
    response = Faraday.get events_url
    meetups = JSON.parse(response.body, symbolize_names: true)

    meetups[:events].collect do |meetup|
      event = Event.where(platform_uid: meetup[:id], platform: meetup[:platform]).first_or_initialize

      event.title = meetup[:name]
      event.description = meetup[:description]
      event.location = meetup[:location]
      event.event_url = meetup[:url]

      event.group_uid = meetup[:group_id]
      event.group_name = meetup[:group_name]
      event.group_url = meetup[:group_url]

      event.formatted_time = meetup[:formatted_time]
      event.start_datetime = meetup[:start_time]
      event.end_datetime = meetup[:end_time]

      event.rsvp_count = meetup[:rsvp_count]

      event
    end
  end
end