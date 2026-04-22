extends CharacterBody2D


@export var speed = 70
var input_movement = Vector2.ZERO

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_movement != Vector2.ZERO:
		$PlayerIdle.visible = false
		$PlayerMove.visible = true
		set_anim()
		anim_state.travel("Move")
		# Velocity -> permet de déplacer le personnage
		velocity = input_movement * speed
	if input_movement == Vector2.ZERO:
		$PlayerMove.visible = false
		$PlayerIdle.visible = true
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
		
	move_and_slide()

func set_anim():
	anim_tree.set("parameters/Idle/blend_position", input_movement)
	anim_tree.set("parameters/Move/blend_position", input_movement)
