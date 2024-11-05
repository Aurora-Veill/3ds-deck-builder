extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") / 100
@export var speed = 0.3
@export var pierce = 1
@export var ignoreWall = false
@export var slow = false
var direction = Vector3.ZERO
var velocityY = 0
@export var dmg = 1
var maker := CharacterBody3D
var ivl = []
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocityY -= gravity * delta 
	position += direction * speed * delta * 60
	position.y += velocityY 
	


func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body != maker and body not in ivl:
		if body.has_node("HP"):
			body.get_node("HP").take_dmg(dmg)
			if slow:
				body.take_slow(1)
			pierce -= 1
			ivl.append(body)
			if pierce <= 0:
				queue_free()
		elif !ignoreWall:
			queue_free()

func set_dir(dir, grav):
	direction = dir
	if (!grav):
		gravity = 0


func _on_timer_timeout():
	queue_free() # Replace with function body.
