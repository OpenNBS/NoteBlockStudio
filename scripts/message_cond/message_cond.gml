function message_cond(str, caption){
	if (os_browser = browser_not_a_browser) {
		if (os_type = os_windows || os_type = os_macosx || os_type = os_linux) {
			return message(str, caption)
		}
		else if (is_mobile()) {
			return show_message_async(str)
		}
	}
}