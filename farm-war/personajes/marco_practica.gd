extends CharacterBody2D

var vida: int = 1000

func _process(delta: float) -> void:
	if vida < 1:
		$Sprite2D.z_index = $Sprite2D.z_index - 1
