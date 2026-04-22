extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var choices = {
		"start": true
	}
	var dm = DialogManager.new("test", choices)
	
	print(dm.get_current_dialog())
	print(dm.get_available_answers())
	dm.choose_dialog("Au revoir.")
	print(dm.get_current_dialog())
	print(dm.get_available_answers())
	dm.choose_dialog("Ok...")
	print(dm.get_current_dialog())
	print(dm.get_available_answers())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
