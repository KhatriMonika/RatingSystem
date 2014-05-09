class EventsController < ApplicationController  
  include Google,GoogleCalendarClientModule
  before_action :set_calendar_client, :update_google_token
  
  def create
    event = {  
      'summary' => params[:summary],
      'location' => params[:location],
      'start' => {
        'dateTime' => params[:sdate].to_datetime
      },
      'end' => {
        'dateTime' => params[:edate].to_datetime
      },
    }
    result = @client.execute(:api_method => @calendar.events.insert,
                             :parameters => {'calendarId' => params[:calendar_id] },
                             :body => JSON.dump(event),
                             :headers => {'Content-Type' => 'application/json'})
    render :action => 'index'
  end

  def index
    
  end
  
  def get_events
    calendar_id = CGI.unescape(params[:calendar_id].to_s)
    result = @client.execute(:api_method => @calendar.events.list,:parameters => {'calendarId' => calendar_id.present? ? calendar_id : 'primary'}) 
    @events = [] 
    result.data.items.each do |event|
      @events << {:id => event.id, :title => event.summary, :description => event.location, :start => "#{event.start.date_time.present? ? event.start.date_time.to_date.iso8601 : event.start.date.to_datetime.iso8601}", :end => "#{event.end.date_time.present? ? event.end.date_time.to_date.iso8601 : event.end.date.to_datetime.iso8601}"}
    end
    respond_to do |format|
      format.js {}
      format.json{render :text => @events.to_json}
    end
  end
end
