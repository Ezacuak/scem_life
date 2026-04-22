extends PanelContainer

@onready var speaker_label = $VBoxContainer/SpeakerName
@onready var text_label    = $VBoxContainer/DialogText

func _ready():
	hide()
	# S'enregistre auprès du DialogManager
	DialogManager.dialog_box = self

func display(speaker: String, text: String):
	speaker_label.text = speaker
	text_label.text    = text
	show()
