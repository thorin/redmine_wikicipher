// encrypt_tag

jsToolBar.prototype.elements.wikicipher = {
  type: 'button',
  title: 'Wikicipher tag',
  fn: {
    wiki: function() { this.encloseSelection('{{cipher(0)', '}}') }
  }
}

window.onload=function(){
	var warn = document.getElementsByClassName('flash warning');
	if (warn.length>0){
		jQuery('.jstb_wikicipher').hide();
	}
};
