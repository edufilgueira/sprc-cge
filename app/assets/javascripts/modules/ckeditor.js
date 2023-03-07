//= require ckeditor/init

$(function(){
'use strict';

  // NÃO precisamos cuidar de "carregar/inicializar" CKEditors.
  // O `require ckeditor/init` no início desse arquivo toma conta disso
  // Ainda, em conteúdos dinâmicos, estamos incluindo esse mesmo javascript para garantir o funcionamento
  //   (em, por exemplo, algum _form.html.haml, caso ele seja `remote: true` e use RemoteForm.js)

});
