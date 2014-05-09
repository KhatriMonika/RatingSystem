module NavigationHelpers

  def path_to(page_name)
    case page_name

      when /^the list of (.*?)$/
        models_prose = $1
        route = "#{model_prose_to_route_segment(models_prose)}_index_path"
        send(route)

      when /^the (page|form) for the (.*?) above$/
        action_prose, model_prose = $1, $2
        route = "#{action_prose == 'form' ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
        model = model_prose.classify.constantize
        send(route, model.last)

      when /^the (page|form) for the (.*?) "(.*?)"$/
        action_prose, model_prose, identifier = $1, $2, $3
        path_to_show_or_edit(action_prose, model_prose, identifier)

      when /^the (.*?) (page|form) for "(.*?)"$/
        model_prose, action_prose, identifier = $1, $2, $3
        path_to_show_or_edit(action_prose, model_prose, identifier)

      when /^the (.*?) form$/
        model_prose = $1
        route = "new_#{model_prose_to_route_segment(model_prose)}_path"
        send(route)

      # ....
      # your own paths go here
      # ...

      when /^the signin page$/
        route = "new_session_path"
         send(route)

      when /^the home page$/
        route = "root_path"
         send(route)

      when /^the assign rating page$/
        route = "employeerate_path"
        send(route)
          
      when /^the reports page$/
        route = "reports_path"
        send(route)

      when /^the date wise line chart$/
        route = "chart_datewise_employees_line_chart_path"
        send(route)

      when /^the factor and date wise chart$/
        route = "chart_datewise_and_factorwise_employees_performance_path"
        send(route)
        
      when /^the overall performance chart$/
        route = "chart_overall_employee_impression_path"
        send(route)
    end
  end

  private

  def path_to_show_or_edit(action_prose, model_prose, identifier)
    model = model_prose.classify.constantize
    route = "#{action_prose == 'form' ? 'edit_' : ''}#{model_prose_to_route_segment(model_prose)}_path"
    send(route, model.find_by_anything!(identifier))
  end

  def model_prose_to_route_segment(model_prose)
    model_prose.gsub(/[\ \/]/, '_')
  end

end

World(NavigationHelpers)