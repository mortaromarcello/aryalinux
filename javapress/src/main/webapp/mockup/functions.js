function toggler(control, text, position) {
	if (position == 1) {
		if (control.value == text) {
			control.value = '';
		}
	}
	if (position == 0) {
		if (control.value == '') {
			control.value = text;
		}
	}
}