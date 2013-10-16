// encrypt_tag

jsToolBar.prototype.elements.wikicipher = {
  type: 'button',
  title: 'Wikicipher tag',
  fn: {
    wiki: function() { this.encloseSelection('{{cipher(0)', '}}') }
  }
}

jQuery(function($){
	if ($('.flash.warning').length > 0){
		$('.jstb_wikicipher').hide();
	}
});
