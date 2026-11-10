# Weapon.gd (arma base) para todas las demas?
extends Node2D
class_name armaBase;
@export var sprite: Sprite2D
@export var ammoEfficiency: float = 1.0 #cuanta balas podras obtener al agarrar municion.
@export var type: int = 1 #del 0 al 5. 0 melee 1 armas de mano 2 corto alcanze 3 alcanse medio 4 largo alcanse 5 armas pesadas 
@export var damage: int = 12 #cuanto daño hace?
@export var automatic: bool = false #sigue disparando mientras sostenga el boton de dispara?
@export var brustFire: bool = false #dispara de forma consecutiva?
@export var brustShots: int = 3 #cuantos disparos maximo puede hacer por rafaga?
@export var fire_rate: float = 1.1 #que tan rapido dispara? cuantos segundos o milisegundos tarda.
var can_shoot: bool = true
@export var cancelReload: bool = false #solo si el arma puede cancelar su recarga para disparar como las escopetas
@export var reloadSpeed: float = 1.1 # cuanto tarda la recarga?
@export var swapSpeed: float = 0.5 # que tan rapido puedo equiparla?
@export var maxAmmo: int = 35 #cuanta municion maximo se puede cargar?
@export var ammo: int = 30 #cuanta municion se esta cargando?
@export var spread: float = 0.07 #cuanto se dispersaran los poryectiles? 0.02 presicion total 0.05 muy presiso 0.07 moderadamente presiso 0.1 poco presiso 0.15 impresiso 0.2 muy impresiso 0.25 completamente impresiso 
@export var spreadMultiplier: float = 1.05 #cuanto se dispersaran si se salta o se dispara de sorma sostenida?
@export var spreadInicial: float = 1.05 #cuanto se dispersaran al primer disparo?
@export var spreadRecover: float = 0.8 #cuanto se recupera por segundo antes de volver al spread inicial? esto mltiplica el spread para reducirlos hasta lelgar al inicial.
@export var pellets: int = 1 #si es una escopeta cuantos perdigones dispara?
@export var maxMag: int = 7 # capacidad máxima del cargador
@export var mag: int = 7 #cuantas balas en el cargador cargador
@export var range: float = 615.0 #alcanze
@export var instantanea: bool = true #si es intantanea no debe usar "parabola" ni "velociadad de proyectil" en la funcion de disparo
@export var speedBullet: float = 2.0 #que tan rapido va el proyectil?
@export var gravity: float = 2.0 #el proyectil trazara una parabola? 
@export var fireEffect: bool = false # el proyectil prende fuego el objetivo? hace 4 de daño por segundo y dura 3 segundos si se le impacta reinicia el contador. 
@export var poisonEffect: bool = false #el proyectil envenena al objetivo? relentiza al objetivo un 30% y solo reduceun punto de vida no afecta armadura y dura 2 segundos.
@export var electricEffect: bool = false #el proyectil envenenaelectrocuta al objetivo? relentiza al objetivo un 70% y impide usar habilidades dura 2 segundos.
@export var explosive: bool = false #solo si es explosiva utilisara el radio explosivo en la funcion de ataque y el tiempo de detonacion 
@export var explosiveRadius: float = 5.0 #que tan grande es la explocion
@export var fuseTime: float = 0.1 #cuanto tarda en detonar en segundos
@export var melee: bool = false #solo si es melee  tendra municion infinita utilisara el barrido en la funcion de ataque y el tiempo de detonacion. 
@export var areaSwing: float = 1.1 #cual es el area de ataque de un arma melee
@export var healthDamageMultiplier: float = 1.0 # que tan efectiva es contra objetivos sin armadura?
@export var armorDamageMultiplier: float = 0.9 # que tan efectiva es contra objetivos con armadura?
@export var headDamageMultiplier: float = 1.8 # que tan efectiva es contra contra la cabeza?
@export var swaping: bool = false #mientres este cambiando no puede hacer otras acciones de armas
var audio_player: AudioStreamPlayer;
var idle: bool = true;
var equipado: bool = true;
func setEquipado() :
	equipado = true;
func setDesquipado() :
	equipado = false;
	
func inactive ():
	await get_tree().create_timer(fire_rate+ 0.2).timeout
	if idle == true:
		$Sprite2D/AnimationPlayer.play("idle", 0.05);
func get_spread_direction(base_rotation: float, spread: float) -> Vector2:
	#angulo base del arma
	var angle = base_rotation
	# Variación aleatoria dentro del rango del spread debo aplicar los mismo para otro numero aleatorios
	var random_offset = randf_range(-spread, spread)
	#aplico variacion
	angle += (random_offset)
	return Vector2.RIGHT.rotated(angle)
func cambiar():
	equipado = false;
	$Sprite2D/AnimationPlayer.play("cambiar", 0.1);
	swaping= true;
	await get_tree().create_timer(swapSpeed).timeout;
	swaping = false;
	equipado = true;
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
	audio_player.play();
	var result = space_state.intersect_ray(query)
	var hit_point = end # por defecto, si no pega en nada, la línea llega hasta el rango máximo y ya

	if result:
		hit_point = result.position
		var hurtbox = result.collider
		if hurtbox.has_method("take_hit"):
			var dmg = damage * (headDamageMultiplier if hurtbox.is_head else healthDamageMultiplier)
			hurtbox.take_hit(dmg)
			apply_effect(hurtbox.owner_entity)
	fireRateCooldown();
	idle = true;
	_draw_trace(muzzle, end);#_draw_trace(muzzle, hit_point);
	inactive();
func fireRateCooldown():
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
func mostrar_temporalmente():
	$Sprite2D/disparoEfecto.show();
	await get_tree().create_timer(0.1).timeout
	$Sprite2D/disparoEfecto.hide();
func reload():
	if !equipado:
		return
	if (maxMag <= ammo) && !swaping && idle:
		#reproducir x animacion
		$Sprite2D/AnimationPlayer.play("recargar", 0.1);
		idle = false;
		await get_tree().create_timer(reloadSpeed).timeout;
		ammo = ammo - maxMag;
		mag = maxMag; 
		idle = true;
		print("Recargando...");
	else:
		if (maxMag > ammo) && !swaping:
			#reproducir x animacion
			# y hacer esperar el tiemnpo de recarga
			mag = ammo;
			ammo = 0;
			print("Recargando...");
		else:
			print("no hay municion...");
	
func equip(): #es probable que weaponholder sea el que administre esto
	print("Arma equipada con velocidad:", swapSpeed);

func apply_effect(target):
	if fireEffect:
		target.apply_fire();
	if electricEffect:
		target.apply_eletric();
	if poisonEffect:
		target.apply_poison();
	if explosive:
		target.apply_explosion(explosiveRadius, fuseTime);

@onready var trace_line: Line2D = $Sprite2D/muzzle/Line2D;#restarle pixeles en Y como en X
#$Line2D  # la linea # analizar posiciones globales 

func _draw_trace(from: Vector2, to: Vector2i):
	trace_line.clear_points()
	trace_line.add_point(to_local(from))
	trace_line.add_point(to_local(to))
	trace_line.visible = true

	await get_tree().create_timer(0.05).timeout
	trace_line.visible = false
func _ready():
	trace_line.width = 5.0
	trace_line.default_color = Color(5.234, 4.239, 0.0, 0.624)
	trace_line.visible = false
	audio_player = AudioStreamPlayer.new();
	add_child(audio_player)
	audio_player.stream = preload("res://sonidos/disparo1wav.wav");

	
	
