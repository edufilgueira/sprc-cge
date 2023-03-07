setTimeout(function() {
  $.ajax({
    url: '/sign_out',
    type:  'DELETE'
  });
}, 2000);

setTimeout(function() {
  window.location.href = '/';
}, 7000);

