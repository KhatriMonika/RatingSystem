// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

//=require dashboard/jquery-1.8.1.min
//=require dashboard/jquery-ui-1.9.2.custom.min  
//=require jquery.nested-fields
//=require dashboard/moment.min
//=require dashboard/daterangepicker
//=require jquery_ujs
//=require dashboard/bootstrap.min
//=require dashboard/gritter
//=require dashboard/jquery.gritter
//=require dashboard/jquery.sparkline.min
//=require dashboard/jquery.dcjqaccordion.2.7
//=require dashboard/fullcalendar
//=require dashboard/jquery.scrollTo.min
//=require dashboard/jquery.nicescroll
//=require dashboard/jquery.multiselect
//=require dashboard/jquery.multiselect.filter
//=require dashboard/jquery.dataTables.js
//=require dashboard/jquery.tagsinput.js
//=require dashboard/bootstrap-switch.js
//=require dashboard/common-scripts
//=require dashboard/highcharts
//=require dashboard/drilldown
//=require dashboard/funnel
//=require dashboard/exporting
//=require dashboard/date_script
//=require dashboard/spectrum.js
//=require jquery.blockUI
//=require_self

$('body').on('click', 'a.gcal_links', function(){
  $.blockUI({ 
      message: '<center><i class="fa fa-spinner fa-spin fa-5x"></i><p>Please Wait</p></center>'
  });
})

$(document).ready(function() {
  datepicker_function();
  $("#leave_reason_category_colour").spectrum({
    preferredFormat: "hex"
  });

  $(".tagsinput").tagsInput();

  $('input[type=radio][name=options]').change(function() {
    if (this.value == 'Textual') {
      $('#employees_performance').hide();          
      $('#employee_rank_table').show();
      $('#leave_report').show();
      $('#leave_chart').hide();
      $('#regular_irregular_employees_table').show();
      $('#regular_irregular_employees').hide();
    }
    else if (this.value == 'Visual') {
      $('#employees_performance').show();          
      $('#employee_rank_table').hide();            
      $('#leave_report').hide();
      $('#leave_chart').show();
      $('#regular_irregular_employees_table').hide();
      $('#regular_irregular_employees').show();
    }
    else {
      $('#employees_performance').show();          
      $('#employee_rank_table').show();
      $('#leave_report').show();
      $('#leave_chart').show();
      $('#regular_irregular_employees_table').show();
      $('#regular_irregular_employees').show();
    }
  });
  

  leave_datepicker();

  $('.sdp').daterangepicker({ singleDatePicker: true });
  $('#satus_id').multiselect();
  $('#employee_id').multiselect().multiselectfilter();
  $('#leave_reason_category_id_in_reports').multiselect();
  $('#factor_id_reports').multiselect();
  
  $('FORM').nestedFields();

  $('a.test').click(function() { 
    var factor_guidline_id = $(this).attr('id');
    if (factor_guidline_id != ''){
      $.ajax
       ({
         dataType: 'script',
         type: 'post',
         url:'/factors/destroy_factor_guidline/'+factor_guidline_id, 
       });
    }
  });

  $('a[disabled=disabled]').click(function(event){
    event.preventDefault(); // Prevent link from following its href
  });

  $(".number").keydown(function (e) {
       if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
           (e.keyCode == 65 && e.ctrlKey === true) || 
           (e.keyCode >= 35 && e.keyCode <= 39) || 
           (e.keyCode == 109) || (e.keyCode == 189)) {
                return;
       }

       if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
           e.preventDefault();
       }
   });

    $('#calendar').fullCalendar({
          editable: true,
          clickable: true,
          droppable: true,
          header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,agendaWeek,agendaDay'
          },
          defaultView: 'month',
          height: 500,
          slotMinutes: 15,
          events: "/events/get_events",
          timeFormat: 'h:mm t{ - h:mm t} ',
          dragOpacity: "0.5",    
      });

      $('#leave_calendar').fullCalendar(
      {
        header: 
        {
            left: 'prev,next today',
            center: 'title',
            right: 'month,basicWeek,basicDay'
        },
        events: "/leaves/get_leaves",   
      });

      $('#dashboard_calendar').fullCalendar(
      {
        header: 
        {
            left: 'prev,next today',
            center: 'title',
            right: 'month,basicWeek,basicDay'
        },
        events: "/dashboard/dashboard_events",   
      });
}); 

function datepicker_function(){
  $("#new_date_value").prop('readonly', 'true');
  $('.dp').daterangepicker({ singleDatePicker: true }, function(date){
    if (date > new Date()){
      alert("Rating cannot be assigned on future Dates");
      var formattedDate = new Date();
      date = formattedDate.getFullYear() + "-" + (formattedDate.getMonth()+1) + "-" + formattedDate.getDate()
      $.ajax
       ({
         dataType: 'script',
         type: 'post',
         url:'/ratings/create_mass_rate', 
         data:{rating_date: date}
       });  
    }
    else{   
      $.ajax
       ({
         dataType: 'script',
         type: 'post',
         url:'/ratings/create_mass_rate', 
         data:{rating_date: date.format("YYYY-MM-DD")}
       });
     }
  });  
}

/**
   * Gets whether all the options are selected
   * @param {jQuery} $el
   * @returns {bool}
   */
  function multiselect_selected($el) {
    var ret = true;
    $('option', $el).each(function(element) {
      if (!!!$(this).prop('selected')) {
        ret = false;
      }
    });
    return ret;
  }
   
  /**
   * Selects all the options
   * @param {jQuery} $el
   * @returns {undefined}
   */
  function multiselect_selectAll($el) {
    $('option', $el).each(function(element) {
      $el.multiselect('select', $(this).val());
    });
  }
  /**
   * Deselects all the options
   * @param {jQuery} $el
   * @returns {undefined}
   */
  function multiselect_deselectAll($el) {
    $('option', $el).each(function(element) {
      $el.multiselect('deselect', $(this).val());
    });
  }
   
  /**
   * Clears all the selected options
   * @param {jQuery} $el
   * @returns {undefined}
   */
  function multiselect_toggle($el, $btn) {
    if (multiselect_selected($el)) {
      multiselect_deselectAll($el);
      $btn.text("Select All");
    }
    else {
      multiselect_selectAll($el);
      $btn.text("Deselect All");
    }
  }


function leave_datepicker(){
  $('.single_dp_leave').daterangepicker({singleDatePicker: true, minDate: new Date},function(date){
    console.log("in leav..........")
    temp = new Date(date);
    if (temp.getDay() == 0)
    {
      month = temp.getMonth() > 8 ? "-" : "-0";
      date = temp.getDate() > 9 ? "-" : "-0";
      tempDate = temp.getFullYear() + month + (temp.getMonth()+1) + date + temp.getDate();
      newDate = temp.getFullYear() + month + (temp.getMonth()+1) + date + (temp.getDate()-1);
      if (tempDate == $('#leave_required_from').val())
      {
        $('#leave_required_from').val(newDate);
      }
      if (tempDate == $('#leave_required_to').val())
      {
        $('#leave_required_to').val(newDate);
      }
      alert("You can not take leave on sunday");
    }
    if (new Date($('#leave_required_to').val())<new Date($('#leave_required_from').val())){
      fromDate = new Date($('#leave_required_from').val());
      month = fromDate.getMonth() > 8 ? "-" : "-0";
      date = fromDate.getDate() > 9 ? "-" : "-0";
      formattedFromDate = fromDate.getFullYear() + month + (fromDate.getMonth()+1) + date + fromDate.getDate();
      $('#leave_required_to').val(formattedFromDate);   
    }
    if ($('#leave_id').val() == "new"){
      $.ajax
      ({
        dataType: 'script',
        type: 'get',
        url:'/leaves/new', 
        data:{leave_required_from: $('#leave_required_from').val(),leave_required_to: $('#leave_required_to').val()}
      });
    } else {
      $.ajax
      ({
        dataType: 'script',
        type: 'get',
        url:'/leaves/'+parseInt($('#leave_id').val())+'/edit', 
        data:{leave_required_from: $('#leave_required_from').val(),leave_required_to: $('#leave_required_to').val()}
      });
    }
  });
}

