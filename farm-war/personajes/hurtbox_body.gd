extends Area2D
@export var damage_multiplier: float = 1.0
@export var is_head: bool = false
@export var owner_entity: Node # referencia al Enemy real

func take_hit(amount: float):
	$"../spriteVivo".hide();
	await get_tree().create_timer(0.1).timeout;
	$"../spriteVivo".show();
func take_damage(amount: int) -> void:
	get_parent().health -= round(amount);  
	 
	if (get_parent().health <= 0):
		$"../spriteVivo".hide();

func die() -> void:
	queue_free()
