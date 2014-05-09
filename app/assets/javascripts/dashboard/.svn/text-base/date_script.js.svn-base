$(function() 
{
    var startDate;
    var endDate;
  var cb = function(start, end) 
  {
    console.log("in callback..........")
    $('.reportrange span').html(start.format('YYYY/MM/DD') + ' - ' + end.format('YYYY/MM/DD'));
    startDate = start.format('YYYY/MM/DD');
    endDate = end.format('YYYY/MM/DD');    
   $('#startdate').val(startDate);
   $('#enddate').val(endDate);
   $('.reportrange').closest('form').submit();
  }

  var optionSet1 = {
    startDate: moment().subtract('days', 29),
    endDate: moment(),
    minDate: '2012/01/01',
    maxDate: '2014/12/31',
    dateLimit: { days: 60 },
    showDropdowns: true,
    showWeekNumbers: true,
    timePicker: false,
    timePickerIncrement: 1,
    timePicker12Hour: true,
    ranges: {
       'Today': [moment(), moment()],
       'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
       'Last 7 Days': [moment().subtract('days', 6), moment()],
       'Last 30 Days': [moment().subtract('days', 29), moment()],
       'This Month': [moment().startOf('month'), moment().endOf('month')],
       'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
    },
    opens: 'left',
    buttonClasses: ['btn btn-default'],
    applyClass: 'btn-small btn-primary',
    cancelClass: 'btn-small',
    format: 'YYYY/MM/DD',
    separator: ' to ',
    locale: {
        applyLabel: 'Submit',
        cancelLabel: 'Clear',
        fromLabel: 'From',
        toLabel: 'To',
        customRangeLabel: 'Custom',
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        firstDay: 1
    }
  };

  var optionSet2 = {
    startDate: moment().subtract('days', 7),
    endDate: moment(),
    opens: 'left',
    ranges: {
       'Today': [moment(), moment()],
       'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
       'Last 7 Days': [moment().subtract('days', 6), moment()],
       'Last 30 Days': [moment().subtract('days', 29), moment()],
       'This Month': [moment().startOf('month'), moment().endOf('month')],
       'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
    }
  };

  $('.reportrange span').html(moment().subtract('days', 29).format('YYYY/MM/DD') + ' - ' + moment().format('YYYY/MM/DD'));

  $('.reportrange').daterangepicker(optionSet1,cb);
 
//  $('.reportrange').on('show', function() { console.log("show event fired"); });
//  $('.reportrange').on('hide', function() { console.log("hide event fired"); });
//  $('.reportrange').on('apply', function(ev, picker) { 
//    console.log("apply event fired, start/end dates are " 
 //     + picker.startDate.format('YYYY/MM/DD') 
  //    + " to " 
   //   + picker.endDate.format('YYYY/MM/DD') 
  //  ); 
 // });
 // $('.reportrange').on('cancel', function(ev, picker) { console.log("cancel event fired"); });


});


$("body").on('change', 'select#project_manager_id' ,function()
{
   $(this).closest('form').submit();
});
$("body").on('change', 'select#factor_id' ,function()
{
   $(this).closest('form').submit();
});
$("body").on('change', 'select#factor_id_reports' ,function()
{
   $(this).closest('form').submit();
});
$("body").on('change', 'select#employee_id' ,function()
{
   $(this).closest('form').submit();
});
$("body").on('change', 'select#satus_id' ,function()
{
   $(this).closest('form').submit();
});
$("body").on('change', 'select#leave_reason_category_id_in_reports' ,function()
{
   $(this).closest('form').submit();
});
