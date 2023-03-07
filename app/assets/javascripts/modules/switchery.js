var switch_elements = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));

switch_elements.forEach(function(html) {
  var switchery = new Switchery(html, { color: '#3489d1', size: 'small' });
});