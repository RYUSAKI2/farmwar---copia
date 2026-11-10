extends armaBase;

func shoot():
	if !equipado:
		return
	if not can_shoot:
		return
	if mag <= 0 || swaping || !idle:
		return
	mag -= 1
	can_shoot = false
	idle = false
	var space_state = get_world_2d().direct_space_state;
	var muzzle = $Sprite2D/muzzle/Line2D.global_position;
	#var direction = -Vector2.RIGHT.rotated(global_rotation)
	var direction = -get_spread_direction(global_rotation, spread)
	var end = muzzle + direction * range
	var query = PhysicsRayQueryParameters2D.create(muzzle, end)
	query.exclude = [self]
	#query.collision_mask = 0b0100 # capa de las hurtboxes?
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	$Sprite2D/AnimationPlayer.play("disparo", 0.1);
	mostrar_temporalmente();
	#agregar audios 
	$Sprite2D/Disparo1Wav2.play();
	var result = space_state.intersect_ray(query)
	var hit_point = end # por defecto, si no pega en nada, la línea llega hasta el rango máximo y ya

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
