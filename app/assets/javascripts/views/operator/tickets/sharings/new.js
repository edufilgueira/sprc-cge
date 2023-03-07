$(function(){
  var last_panel = $('div[data-content="tickets"], div[data-content="department"]').last();
  var switch_elements = Array.prototype.slice.call($('.js-switch', last_panel));

  switch_elements.forEach(function(html) {
    var switchery = new Switchery(html, { color: '#3489d1', size: 'small' });
  });
});