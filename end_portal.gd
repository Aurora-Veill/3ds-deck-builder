extends Node3D

signal entered()
var Player : player
@export var spawnTo = "res://Lvl2.tscn"
func _ready():
	$SpawnNoise.play()

func look():
	if Player:
		look_at_from_position(position, Player.global_position)
	

func _process(_delta):
	rotation.x = 0
	if Player:
		Player.objTarget = global_position
		Player.objActive = true

func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.has_method("player"):
		emit_signal("entered")
