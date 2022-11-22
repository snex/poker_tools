require('imports-loader?define=>false,this=>window!datatables.net')(window, $)
require('imports-loader?define=>false,this=>window!datatables.net-bs4')(window, $)
require('yadcf')
require('chosen-js')
require('jquery-ui/ui/widgets/datepicker')
require('chart.js')

const monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

window.globalThis.updateCharts = (isoDate) => {
  var newDate = new Date(Date.parse(isoDate));
  var curYear = parseInt($('#yearchart').data().year);
  var year = newDate.getYear() + 1900;
  var month = newDate.getMonth() + 1;

  if (curYear != year) {
    $('#yearchart').data('year', year);
    $.ajax({
      url:      $('#yearchart').data('url'),
      data:     {
        year: year
      },
      async:    true,
      dataType: 'json',
      type:     'GET'
    }).done(function(data) {
      var yearChartContext = $('#yearchart').get(0).getContext('2d');
      var yearChart = new Chart(yearChartContext, {
        type: 'line',
        data: {
          labels: data.dates,
          datasets: [
            {
              label:       year,
              data:        data.datapoints,
              lineTension: 0,
              fill:        false,
              pointRadius: 0,
              borderColor: 'rgb(0, 192, 192)'
            }
          ]
        }
      });
    });
  }

  $.ajax({
    url:      $('#monthchart').data('url'),
    data:     {
      year:  year,
      month: month
    },
    async:    true,
    dataType: 'json',
    type:     'GET'
  }).done(function(data) {
    var monthChartContext = $('#monthchart').get(0).getContext('2d');
    var monthChart = new Chart(monthChartContext, {
      type: 'line',
      data: {
        labels: data.dates,
        datasets: [
          {
            label:       monthNames[month - 1] + ' ' + year,
            data:        data.datapoints,
            lineTension: 0,
            fill:        false,
            pointRadius: 0,
            borderColor: 'rgb(0, 192, 192)'
          }
        ]
      }
    });
  });
}

$(document).ready(function() {
  var curYear = new Date().getYear() + 1900;
  var today = new Date().toISOString();
  today = today.substring(0, today.indexOf('T'));
  window.globalThis.updateCharts(today);

  $.ajax({
    url:      $('#allchart').data('url'),
    async:    true,
    dataType: 'json',
    type:     'GET'
  }).done(function(data) {
    var allChartContext = $('#allchart').get(0).getContext('2d');
    var allChart = new Chart(allChartContext, {
      type: 'line',
      data: {
        labels: data.dates,
        datasets: [
          {
            label:       'All Time',
            data:        data.datapoints,
            lineTension: 0,
            fill:        false,
            pointRadius: 0,
            borderColor: 'rgb(0, 192, 192)'
          }
        ]
      }
    });
  });
  $.ajax({
    url:      $('#yearchart').data('url'),
    async:    true,
    dataType: 'json',
    type:     'GET'
  }).done(function(data) {
    var yearChartContext = $('#yearchart').get(0).getContext('2d');
    var yearChart = new Chart(yearChartContext, {
      type: 'line',
      data: {
        labels: data.dates,
        datasets: [
          {
            label:       curYear,
            data:        data.datapoints,
            lineTension: 0,
            fill:        false,
            pointRadius: 0,
            borderColor: 'rgb(0, 192, 192)'
          }
        ]
      }
    });
  });

  $('#upload-session').click(function () {
    var fileDialog = document.createElement('input');
    fileDialog.type = 'file';
    fileDialog.accept = '.txt,text/plain';
    fileDialog.addEventListener('change', function(e) {
      var formData = new FormData();
      formData.append('file', e.path[0].files[0]);
      $.post({
        url:         'poker_sessions/upload',
        data:        formData,
        processData: false,
        contentType: false,
        success: function(e) {
          location.reload();
        },
        error: function(e) {
          alert('there was an error uploading the file: ' + e.responseText);
        }
      });
    });
    fileDialog.dispatchEvent(new MouseEvent('click'));
  });

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
