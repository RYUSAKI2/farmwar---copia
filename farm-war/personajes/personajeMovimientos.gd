extends CharacterBody2D

const SPEED = 250.0;
const JUMP_VELOCITY = -710.0;
var can_double_jump = true;
const maxHealt = 200.0;
var healt = 100.0;
const maxArmor = 200.0;
var armor = 100.0;
@onready var sprite = $Sprite2D
var armas = [$Sprite2D/manitos/ArmaCajita,$Sprite2D/manitos/ArmaCajita2
,$Sprite2D/manitos/ArmaCajita3,$Sprite2D/manitos/ArmaCajita4
,$Sprite2D/manitos/ArmaCajita5,$Sprite2D/manitos/ArmaCajita6]; 
var puntero = 1;
var arma_actual = 0;
var min_top = PI/3;            
var max_top = 2*PI/3;          
var min_bottom = deg_to_rad(200);   
var max_bottom = deg_to_rad(340);   
var doritos: bool;
var armaEquipada= armas[0];

func _physics_process(delta: float) -> void:
	# Gravedad
	floor_max_angle = deg_to_rad(46);
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimationPlayer.play("caida",0.2);
	# Saltar y doble salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;
		
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump:
		velocity.y = JUMP_VELOCITY;
		can_double_jump = false;

	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED;#derecha
		#move_and_slide();
		if is_on_floor():
			$AnimationPlayer.play("walk",0.2);
			can_double_jump = true;
	##elif direction == 0:
	##	$AnimationPlayer.play("idle",0.5);
	##	if not is_on_floor():
	##		$AnimationPlayer.play("caida",0.5);
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if is_on_floor():
			$AnimationPlayer.play("idle",0.4);
			can_double_jump = true;
	move_and_slide();
	
@export var armaCaja: Node2D;
func _process(delta):
	if Input.is_action_just_pressed("cambiar siguiente"):
		armaEquipada.setDesquipado()
		armaEquipada.hide()
		puntero = (puntero + 1) % armas.size()
		armaEquipada = armas[puntero]
		armaEquipada.show()
		armaEquipada.cambiar()
	if Input.is_action_just_pressed("cambiar anterior"):
		armaEquipada.setDesquipado()
		armaEquipada.hide()
		puntero = (puntero - 1 + armas.size()) % armas.size();
		armaEquipada = armas[puntero]
		armaEquipada.show()
		armaEquipada.cambiar()
	if Input.is_action_just_pressed("disparar"):
		armaEquipada.shoot();
	if Input.is_action_just_pressed("recargar"):
		armaEquipada.reload();
	var mouse_pos = get_global_mouse_position();
	var angle_to_mouse = (mouse_pos - global_position).angle();

	if angle_to_mouse > min_top and angle_to_mouse < max_top:
		if angle_to_mouse < (min_top + max_top) / 2:
			angle_to_mouse = min_top;
		else:
			angle_to_mouse = max_top;

	if angle_to_mouse > min_bottom and angle_to_mouse < max_bottom:
		if angle_to_mouse > (min_bottom + max_bottom) / 2:
			angle_to_mouse = min_bottom;
		else:
			angle_to_mouse = max_bottom;

	if mouse_pos.x > global_position.x:
		angle_to_mouse += PI/12;
		sprite.scale.x = -1;
		$Sprite2D/SpriteCabeza.rotation = -angle_to_mouse;
		$Sprite2D/manitos.rotation = -angle_to_mouse;
		$Sprite2D/SpriteCabeza.scale = Vector2(1,1);
		$Sprite2D/manitos.scale = Vector2(1,1);
	else:
		angle_to_mouse -= PI/12;
		sprite.scale.x = 1;
		$Sprite2D/SpriteCabeza.scale = Vector2(-1,-1);
		$Sprite2D/manitos.scale = Vector2(-1,-1);
		$Sprite2D/SpriteCabeza.rotation = angle_to_mouse;
		$Sprite2D/manitos.rotation = angle_to_mouse;

	
func _on_hijo_pedir_animacion():
	$AnimationPlayer.play("disparo")
	
