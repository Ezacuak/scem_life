extends CharacterBody2D


@export var speed = 70
var input_movement = Vector2.ZERO

func _physics_process(delta: float) -> void:
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_movement != Vector2.ZERO:
		# Velocity -> permet de déplacer le personnage
		velocity = input_movement * speed
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
		
	move_and_slide()
