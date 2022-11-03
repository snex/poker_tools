require('jquery-ui/ui/widgets/datepicker')
require('chosen-js')

$(document).ready(function() {
  $('#bet-size-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-bet-size').click(function() {
    $('#bet-size-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#hand-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-hand').click(function() {
    $('#hand-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#position-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-position').click(function() {
    $('#position-select').val('').trigger('chosen:updated');
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

  $('#flop-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-flop').click(function() {
    $('#flop-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#turn-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-turn').click(function() {
    $('#turn-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#river-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-river').click(function() {
    $('#river-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#showdown-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-showdown').click(function() {
    $('#showdown-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });

  $('#all-in-select').chosen({width: '250px'}).change(function(e, opt) {
    $('#filter-form').submit();
  });
  $('#reset-all-in').click(function() {
    $('#all-in-select').val('').trigger('chosen:updated');
    $('#filter-form').submit();
  });
});
