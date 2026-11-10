extends CanvasLayer
# Crosshair.gd (HUD)
@export var base_size: float = 16.0
var current_spread: float = 0.0
var global_position: Vector2;
func update_crosshair(spread: float):
	current_spread = spread
	$CrosshairSprite.scale = Vector2.ONE * (1.0 + spread * 0.1)
	global_position = get_viewport().get_mouse_position()
