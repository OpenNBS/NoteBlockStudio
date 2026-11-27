function message_yesnocancel(argument0, argument1) {
	// message_yesnocancel(text, caption)
	var a;
	widget_set_caption(string(argument1))
	a = show_question_cancelable(string(argument0))
	return a


}
