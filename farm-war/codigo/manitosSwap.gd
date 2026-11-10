extends Node

var weapon_index := 0
var weapons := [$ArmaCajita,$ArmaCajita2,$ArmaCajita3,$ArmaCajita4,$ArmaCajita5,$ArmaCajita6];

func _ready():
	weapons = get_children();
	update_weapon();

func _input(event):
	if event.is_action_pressed("cambiar siguiente"):
		weapon_index = (weapon_index + 1) % weapons.size()
		update_weapon();

	elif event.is_action_pressed("cambiar anterior"):
		weapon_index = (weapon_index - 1 + weapons.size()) % weapons.size()
		update_weapon();

func update_weapon():
	for weapon in weapons:
		weapon.visible = false
		#weapon.get_children().cambiar();
		#weapon.cambiar();
	weapons[weapon_index].visible = true
