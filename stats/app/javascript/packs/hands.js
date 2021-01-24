require('jquery-ui/ui/widgets/datepicker')
require('chosen-js')

$(document).ready(function() {
  $('#position-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-position').click(function() {
    $('#position-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#bet-size-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-bet-size').click(function() {
    $('#bet-size-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#table-size-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-table-size').click(function() {
    $('#table-size-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#stake-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-stake').click(function() {
    $('#stake-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#from-filter').datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: function() {
      $('#filter-form').submit();
    }
  });
  $('#to-filter').datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: function() {
      $('#filter-form').submit();
    }
  });
  $('#reset-from').click(function() {
    $('#from-filter').val('');
    $('#filter-form').submit();
  });
  $('#reset-to').click(function() {
    $('#to-filter').val('');
    $('#filter-form').submit();
  });
});
