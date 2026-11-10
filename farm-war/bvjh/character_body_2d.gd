extends CharacterBody2D

const SPEED = 2000
const JUMP_VELOCITY = -1020.0
const FALL_GRAVITY_MULTIPLIER = 4.0# Ajusta este valor para controlar la velocidad de caída

# 1. Creamos el contador y el límite máximo de saltos
var saltos_realizados: int = 0
const MAX_SALTOS: int = 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			# Aplica más gravedad únicamente cuando el personaje está cayendo
			velocity += get_gravity() * delta * FALL_GRAVITY_MULTIPLIER
		else:
			# Gravedad normal mientras el personaje va subiendo
			velocity += get_gravity() * delta
	else:
		# 2. Si toca el suelo, reiniciamos el contador a 0
		saltos_realizados = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and saltos_realizados < MAX_SALTOS:
		velocity.y = JUMP_VELOCITY
		saltos_realizados += 1

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("izquierda", "derecha")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
