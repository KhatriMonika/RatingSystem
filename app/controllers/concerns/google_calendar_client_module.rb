module GoogleCalendarClientModule
  require 'google/api_client'
  require 'client_builder'
  def set_calendar_client(current_user)
    @ids = Hash.new
    if current_user.present?
      @client = ClientBuilder.get_client(current_user)
      @calendar = @client.discovered_api('calendar', 'v3')
      result = @client.execute(:api_method => @calendar.calendar_list.list)
      @calendars = result.data
      @calendars.items.each do |calendar|
        @ids[calendar["summary"]] = calendar["id"]
      end
    end
  end

  def google_calendar_event_insert(calendar_id,summary,sdate,edate)
    event = {'summary' => summary,'location' => 'Complitech','start' => {'dateTime' => sdate,'timeZone' => 'GMT+5:30'},'end' => {'dateTime' => edate ,'timeZone' => 'GMT+5:30'}}
    result = @client.execute(:api_method => @calendar.events.insert,
                      :parameters => {'calendarId' => calendar_id},
                      :body_object => event,
                      :headers => {'Content-Type' => 'application/json'})
    return result.data.id
  end

  def google_calendar_event_update(calendar_id,event_id,summary,sdate,edate)
    result = @client.execute(:api_method => @calendar.events.get,:parameters => {'calendarId' => calendar_id, 'eventId' => event_id})
    event = result.data
    event.summary = summary
    event.start.dateTime = sdate
    event.end.dateTime = edate
    result = @client.execute(:api_method => @calendar.events.update,:parameters => {'calendarId' => calendar_id, 'eventId' => event.id},:body_object => event,:headers => {'Content-Type' => 'application/json'})
  end

  def google_calendar_event_remove(calendar_id,event_id)
    result = @client.execute(:api_method => @calendar.events.delete,:parameters => {'calendarId' => calendar_id, 'eventId' => event_id})
  end

  def sync_employee_birthdate_with_google(summary, employee, birthdate)
    @employee = employee
    set_calendar_client(@employee)
    if @employee.event_id_birthdate.present?
      employee_date_google_update(@employee.event_id_birthdate,summary,birthdate.to_time,birthdate.to_time)
    else    
      @employee.event_id_birthdate = employee_date_google_insert(summary,birthdate.to_time,birthdate.to_time)
    end   
  end

  def sync_employee_joining_date_with_google(summary, employee, joining_date)
    @employee = employee
    set_calendar_client(@employee)
     if @employee.joining_date.present?
      employee_date_google_update(@employee.event_id_joining_date,summary,joining_date.to_time,joining_date.to_time)
    else    
      @employee.event_id_joining_date = employee_date_google_insert(summary,joining_date.to_time,joining_date.to_time)
    end
  end

  def employee_date_google_update(event_id,summary,sdate,edate)
    result = @client.execute(:api_method => @calendar.events.get,:parameters => {'calendarId' => 'primary', 'eventId' => event_id})
    event = result.data
    event.summary = summary
    event.start.dateTime = sdate
    event.end.dateTime = edate
    result = @client.execute(:api_method => @calendar.events.update,:parameters => {'calendarId' => 'primary', 'eventId' => event.id},:body_object => event,:headers => {'Content-Type' => 'application/json'})
  end

  def employee_date_google_insert(summary,sdate,edate)
    event = {'summary' => summary,'location' => 'Complitech','start' => {'dateTime' => sdate,'timeZone' => 'GMT+5:30'},'end' => {'dateTime' => edate ,'timeZone' => 'GMT+5:30'},'recurrence' => ["RRULE:FREQ=YEARLY"]}
    result = @client.execute(:api_method => @calendar.events.insert,
                      :parameters => {'calendarId' => 'primary'},
                      :body_object => event,
                      :headers => {'Content-Type' => 'application/json'})
    return result.data.id
  end
end
