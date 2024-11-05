extends Node3D

var MRadius = 10
var radius = 0.001
var damage = 1
var maker := CharacterBody3D
var ivl = []
@onready var collider = $Area3D/CollisionShape3D
@onready var sprite = $CSGTorus3D
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	radius += (MRadius * delta)/0.25
	if collider:
		collider.shape.radius = radius
	if sprite:
		sprite.inner_radius = radius
		sprite.outer_radius = radius + 0.25
	if radius >= MRadius:
		queue_free()


func _on_area_3d_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body != maker and body not in ivl:
		if body.has_node("HP"):
			body.get_node("HP").take_dmg(damage)
			ivl.append(body)
