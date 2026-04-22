extends Node

signal dialog_opened
signal dialog_closed

var is_open: bool = false
var dialog_box  # référence à la scène UI

func show_dialog(speaker: String, text: String):
	is_open = true
	if dialog_box:
		dialog_box.display(speaker, text)
	emit_signal("dialog_opened")

func close_dialog():
	is_open = false
	if dialog_box:
		dialog_box.hide()
	emit_signal("dialog_closed")
	
