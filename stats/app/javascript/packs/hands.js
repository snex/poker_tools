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
});
