require('imports-loader?define=>false,this=>window!datatables.net')(window, $)
require('imports-loader?define=>false,this=>window!datatables.net-bs4')(window, $)
require('yadcf')
require('chosen-js')
require('jquery-ui/ui/widgets/datepicker')
require('chart.js')

var chart;
var betSizeLabels = [
  { text: 'limp', fillStyle: 'red', strokeStyle: 'red', lineWidth: 2, hidden: false, index: 1 },
  { text: '2b', fillStyle: 'orange', strokeStyle: 'orange', lineWidth: 2, hidden: false, index: 2 },
  { text: '3b', fillStyle: 'yellow', strokeStyle: 'yellow', lineWidth: 2, hidden: false, index: 3 },
  { text: '4b', fillStyle: 'green', strokeStyle: 'green', lineWidth: 2, hidden: false, index: 4 },
  { text: '5b', fillStyle: 'blue', strokeStyle: 'blue', lineWidth: 2, hidden: false, index: 5 },
  { text: '6b', fillStyle: 'purple', strokeStyle: 'purple', lineWidth: 2, hidden: false, index: 6 },
];

var positionLabels = [
  { text: 'SB', fillStyle: '#c10001', strokeStyle: '#c10001', lineWidth: 2, hidden: false, index: 1 },
  { text: 'BB', fillStyle: '#ff8f00', strokeStyle: '#ff8f00', lineWidth: 2, hidden: false, index: 2 },
  { text: 'UTG', fillStyle: '#edff5b', strokeStyle: '#edff5b', lineWidth: 2, hidden: false, index: 3 },
  { text: 'UTG1', fillStyle: '#52e000', strokeStyle: '#52e000', lineWidth: 2, hidden: false, index: 4 },
  { text: 'MP', fillStyle: '#1a9391', strokeStyle: '#1a9391', lineWidth: 2, hidden: false, index: 5 },
  { text: 'LJ', fillStyle: '#00c4da', strokeStyle: '#00c4da', lineWidth: 2, hidden: false, index: 6 },
  { text: 'HJ', fillStyle: '#610c8c', strokeStyle: '#610c8c', lineWidth: 2, hidden: false, index: 7 },
  { text: 'CO', fillStyle: '#d223fe', strokeStyle: '#d223fe', lineWidth: 2, hidden: false, index: 8 },
  { text: 'BU', fillStyle: '#b30347', strokeStyle: '#b30347', lineWidth: 2, hidden: false, index: 9 },
  { text: 'UTG2/STRADDLE', fillStyle: 'black', strokeStyle: 'black', lineWidth: 2, hidden: false, index: 10 },
];
var currentLabels = betSizeLabels;

Chart.defaults.multicolorLine = Chart.defaults.line;
Chart.controllers.multicolorLine = Chart.controllers.line.extend({
  draw: function(ease) {
    var
    startIndex = 0,
      meta = this.getMeta(),
      points = meta.data || [],
      colors = this.getDataset().colors,
      area = this.chart.chartArea,
      originalDatasets = meta.dataset._children
      .filter(function(data) {
        return !isNaN(data._view.y);
      });

    function _setColor(newColor, meta) {
      meta.dataset._view.borderColor = newColor;
    }

    if (!colors) {
      Chart.controllers.line.prototype.draw.call(this, ease);
      return;
    }

    for (var i = 2; i <= colors.length; i++) {
      if (colors[i-1] !== colors[i]) {
        _setColor(colors[i-1], meta);
        meta.dataset._children = originalDatasets.slice(startIndex, i);
        meta.dataset.draw();
        startIndex = i - 1;
      }
    }

    meta.dataset._children = originalDatasets.slice(startIndex);
    meta.dataset.draw();
    meta.dataset._children = originalDatasets;

    points.forEach(function(point) {
      point.draw(area);
    });
  }
});

$(document).ready(function() {
  var updateStats = function(num, sum, pct, avg, stddev) {
    $('#hand-count').text(num);
    $('#hand-sum').text(sum);
    $('#hand-pct').text(pct);
    $('#hand-avg').text(avg);
    $('#hand-stddev').text(stddev);

    if (sum < 0) {
      $('#stats-table').removeClass('alert-success');
      $('#stats-table').addClass('alert-danger');
    } else if (sum > 0) {
      $('#stats-table').removeClass('alert-danger');
      $('#stats-table').addClass('alert-success');
    } else {
      $('#stats-table').removeClass('alert-danger');
      $('#stats-table').removeClass('alert-success');
    }
  }

  var updateChart = function(data) {
    $.ajax({
      url:      $('#datachart').data('url'),
      async:    true,
      dataType: 'json',
      type:     'POST',
      data:     data
    }).done(function(data) {
      updateStats(data.hand_count, data.hand_sum, data.hand_pct, data.hand_avg, data.hand_stddev);

      if ($('#datachart').length == 0) {
        return;
      }

      var context = $('#datachart').get(0).getContext('2d');

      if (chart) {
        chart.destroy();
      }
      chart = new Chart(context, {
        type: 'multicolorLine',
        data: {
          labels: data.ids,
          datasets: [
            { 
              data: data.datapoints,
              lineTension: 0,
              fill: false,
              borderColor: data.colors,
              pointRadius: 1,
              pointHitRadius: 3,
              colors: data.bet_size_colors,
              dates: data.dates,
              notes: data.notes,
              results: data.results,
              betSizeColors: data.bet_size_colors,
              positionColors: data.position_colors
            }
          ]
        },
        options: {
          legend: {
            display: true,
            onClick: function() {
              if (currentLabels == betSizeLabels) {
                currentLabels = positionLabels;
                chart.data.datasets[0].colors = chart.data.datasets[0].positionColors;
              } else {
                currentLabels = betSizeLabels;
                chart.data.datasets[0].colors = chart.data.datasets[0].betSizeColors;
              }
              chart.update();
              return false;
            },
            labels: {
              generateLabels: function() {
                return currentLabels;
              }
            }
          },
          tooltips: {
            callbacks: {
              afterLabel: function(tooltipItem, data) {
                var result = data.datasets[tooltipItem.datasetIndex].results[tooltipItem.index];
                var note_lines = data.datasets[tooltipItem.datasetIndex].notes[tooltipItem.index].split("\n");
                note_lines.unshift(result);
                return note_lines;
              },
              label: function(tooltipItem, data) {
                var date = data.datasets[tooltipItem.datasetIndex].dates[tooltipItem.index];
                return date;
              },
              title: function(a, b) {
                return '';
              }
            }
          }
        }
      });
    });
  }

  if ($('#hh-datatable').length > 0) {
    var dt = $('#hh-datatable').DataTable({
      'processing': true,
      'serverSide': true,
      'dom': 'iprtip',
      'ajax': {
        'url': $('#hh-datatable').data('source'),
        'type': 'POST'
      },
      'createdRow': function(row, data, dataIndex) {
        if (data.result < 0) {
          $(row).addClass('alert-danger');
        } else if (data.result > 0) {
          $(row).addClass('alert-success');
        }
      },
      'pagingType': 'full_numbers',
      'columns': [
        {'data': 'date'},
        {'data': 'result'},
        {'data': 'hand'},
        {'data': 'position'},
        {'data': 'bet_size'},
        {'data': 'table_size'},
        {'data': 'flop', 'orderable': false},
        {'data': 'turn', 'orderable': false},
        {'data': 'river', 'orderable': false},
        {'data': 'showdown'},
        {'data': 'all_in'},
        {'data': 'note'}
      ],
      'columnDefs': [
        {'width': '5%', 'targets': [0,1,2,3,4,5]}
      ]
    });

    dt.on('preXhr', function(e, s, d) {
      updateChart($.param(d))
    });

    yadcf.init(dt, [
      { column_number: 0, filter_type: 'range_date', date_format: 'yyyy-mm-dd', filter_delay: 500 },
      { column_number: 1, filter_type: 'range_number', exclude: true, exclude_label: 'Use ABS', filter_delay: 500 },
      { column_number: 2, filter_type: 'multi_select', data: $('#hands').data('hands'), sort_as: 'none', filter_match_mode: 'exact', select_type: 'chosen', select_type_options: {width: '100px'} },
      { column_number: 3, filter_type: 'multi_select', data: $('#positions').data('positions'), sort_as: 'none', filter_match_mode: 'exact', select_type: 'chosen' },
      { column_number: 4, filter_type: 'multi_select', data: $('#bet-sizes').data('bet-sizes'), filter_match_mode: 'exact', select_type: 'chosen' },
      { column_number: 5, filter_type: 'multi_select', data: $('#table-sizes').data('table-sizes'), sort_as: 'none', filter_match_mode: 'exact', select_type: 'chosen' },
      { column_number: 6, filter_type: 'select', data: [true, false] },
      { column_number: 7, filter_type: 'select', data: [true, false] },
      { column_number: 8, filter_type: 'select', data: [true, false] },
      { column_number: 9, filter_type: 'select', data: [true, false] },
      { column_number: 10, filter_type: 'select', data: [true, false] },
    ]);

    var default_search = [];
    var default_search_data = $('#default-search').data('default-search');

    if ('bet_size' in default_search_data) {
      default_search.push([4, default_search_data.bet_size]);
    }
    if ('hand' in default_search_data) {
      default_search.push([2, default_search_data.hand]);
    }
    if ('position' in default_search_data) {
      default_search.push([3, default_search_data.position]);
    }
    if ('table_size' in default_search_data) {
      default_search.push([5, default_search_data.table_size]);
    }

    yadcf.exFilterColumn(dt, default_search);
  }
});
