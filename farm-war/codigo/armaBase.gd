extends Node2D
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
@export var mag: int = 700 #cuantas balas en el cargador cargador
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
func inactive ():
	await get_tree().create_timer(fire_rate+ 0.2).timeout
	if idle == true:
		$AnimationPlayer.play("idle", 0.1);
func get_spread_direction(base_rotation: float, spread: float) -> Vector2:
	#angulo base del arma
	var angle = base_rotation
	# Variación aleatoria dentro del rango del spread debo aplicar los mismo para otro numero aleatorios
	var random_offset = randf_range(-spread, spread)
	#aplico variacion
	angle += (random_offset)
	return Vector2.RIGHT.rotated(angle)
func cambiar():
	$AnimationPlayer.play("cambiar", 0.1);
	swaping= true;
	await get_tree().create_timer(swapSpeed).timeout;
	swaping = false;
