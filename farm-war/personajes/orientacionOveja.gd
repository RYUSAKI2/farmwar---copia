extends Node2D
@onready var sprite = $"."/ovejaBody2D/Sprite2D

func _process(delta):
	# Posición del mouse en coordenadas globales
	var mouse_pos = get_global_mouse_position()

	# Si el mouse está a la derecha del personaje
	if mouse_pos.x > global_position.x:
		sprite.flip_h = false   # mirando a la derecha
	else:
		sprite.flip_h = true    # mirando a la izquierda
