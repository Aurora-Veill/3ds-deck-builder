extends Node3D

@export var animation : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("mixamo_com")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
