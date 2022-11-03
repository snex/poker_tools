require('imports-loader?define=>false,this=>window!datatables.net')(window, $)
require('imports-loader?define=>false,this=>window!datatables.net-bs4')(window, $)
require('yadcf')
require('chosen-js')
require('jquery-ui/ui/widgets/datepicker')
require('chart.js')

$(document).ready(function() {
  if ($('#ps-datatable').length > 0) {
    var dt = $('#ps-datatable').DataTable({
      'processing': true,
      'serverSide':  true,
      'dom':        'iprtip',
      'ajax': {
        'url':  $('#ps-datatable').data('source'),
        'type': 'POST'
      },
      'createdRow': function(row, data, dataIndex) {
        if (data.result < 0) {
          $(row).addClass('alert-danger');
        } else if (data.result > 0) {
          $(row).addClass('alert-success');
        }
      },
      'paging_type': 'full_numbers',
      'columns': [
        {'data': 'start_time'},
        {'data': 'end_time'},
        {'data': 'duration'},
        {'data': 'game_type'},
        {'data': 'buyin'},
        {'data': 'cashout'},
        {'data': 'result'},
        {'data': 'hands_dealt'},
        {'data': 'hands_played'},
        {'data': 'saw_flop'},
        {'data': 'wtsd'},
        {'data': 'wmsd'},
        {'data': 'vpip'}
      ],
      'order': [[0, 'desc']]
    });
  }
});
