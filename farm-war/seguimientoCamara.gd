extends Camera2D

@export var max_offset: float = 350.0
@export var smoothness: float = 0.05

func _process(delta):
	# Posición del mouse en coordenadas globales
	var mouse_pos = get_global_mouse_position();

	# Vector desde el jugador (el padre) hacia el mouse
	var offset = mouse_pos - get_parent().global_position;

	# Limitar distancia máxima
	if offset.length() > max_offset:
		offset = offset.normalized() * max_offset;

	# Como hija del jugador, usamos posición local
	position = position.lerp(offset, smoothness);
