extends CharacterBody2D
const SPEED = 250.0
const JUMP_VELOCITY = -690.0
@onready var sprite = $Sprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	# Posición del mouse en coordenadas globales
	var mouse_pos = get_global_mouse_position()

	# Si el mouse está a la derecha del personaje
	if mouse_pos.x > global_position.x:
		sprite.flip_h = false   # mirando a la derecha
	else:
		sprite.flip_h = true    # mirando a la izquierda
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Voltear sprite según dirección
	
	move_and_slide()
