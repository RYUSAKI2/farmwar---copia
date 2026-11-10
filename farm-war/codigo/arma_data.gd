# arma_data.gd
class_name ArmaData
#extends ItemData   # el que hicimos antes, con nombre, icono y escena

@export var damage: float = 10.0
@export var head_multiplier: float = 2.0
@export var body_multiplier: float = 1.0
@export var spread: float = 0.05
@export var range: float = 1000.0
@export var mag_size: int = 12
@export var fire_rate: float = 0.2
@export var sonido_disparo: AudioStream

# estado que cambia en juego
var mag: int = 0
