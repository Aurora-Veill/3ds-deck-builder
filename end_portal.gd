extends Node3D

signal entered()
var player
@export var spawnTo = "res://Lvl2.tscn"
func _ready():
	$SpawnNoise.play()

func look():
	if player:
		look_at_from_position(position, player.global_position)
		rotation.y = 0

func _process(_delta):
	if player:
		player.objTarget = global_position
		player.objActive = true

func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.has_method("player"):
		emit_signal("entered")
