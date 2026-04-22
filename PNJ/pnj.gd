extends CharacterBody2D

# Les dialogues du PNJ
@export var dialogues: Array[String] = [
	"Bonjour, voyageur !",
	"Le donjon au nord est dangereux...",
    "Bonne chance dans ta quête !"
]

@export var npc_name: String = "PNJ_Test"

var player_nearby: bool = false
var dialogue_index: int = 0

@onready var label = $Label
@onready var detection_zone = $DetectionZone

func _ready():
	label.hide()
	
	# Connecte les signaux de la zone de détection
	detection_zone.body_entered.connect(_on_player_entered)
	detection_zone.body_exited.connect(_on_player_exited)

func _process(_delta):
	# Détecte la touche d'interaction
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()

func _on_player_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		label.show()

func _on_player_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		label.hide()
		# Ferme la boîte de dialogue si ouverte
		DialogManager.close_dialog()

func interact():
	var line = dialogues[dialogue_index]
	DialogManager.show_dialog(npc_name, line)
	
	# Avance au prochain dialogue (boucle)
	dialogue_index = (dialogue_index + 1) % dialogues.size()
