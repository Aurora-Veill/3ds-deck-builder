extends Enemy

var speed = 6.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var target := Node3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var canAttack = true
var isSlow = false
var dmg = 1
@onready var nav = $navigator
@onready var atkCD = $AtkCooldown
var animTree
signal onDeath(x, y, z)

func _ready():
	animTree = $AnimationTree
	animTree.set("parameters/transition/transition_request", "idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var direction = Vector3.ZERO
	if !target:
		return
	move_and_slide()
	look_at(target.global_position)
	rotation.x = 0
	rotation.z = 0
	if animTree["parameters/OneShot/active"]:
		return
	if position.distance_to(target.global_position) < 1.5:
		velocity = Vector3.ZERO
		animTree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	else:
		if position.distance_to(target.global_position) > 50:
			animTree["parameters/transition/transition_request"] = "idle"
			velocity.x = 0
			velocity.z = 0
			return
		animTree["parameters/transition/transition_request"] = "walk"
		nav.set_target_position(target.global_position)
		direction = (nav.get_next_path_position() - global_position).normalized()
		velocity = velocity.lerp(direction * speed, delta)
		if isSlow:
			velocity = velocity.lerp(direction * speed * 0.5, delta)
	
func attack(Projectile: PackedScene) -> void:
	var atk = Projectile.instantiate()
	atk.position = position
	atk.set_dir((target.position - position).normalized(), false)
	atk.maker = self
	get_parent().add_child(atk)
		
func _on_hp_on_death():
	onDeath.emit(position)
	queue_free() # Replace with function body.

	

func _on_atk_cooldown_timeout():
	canAttack = true # Replace with function body.


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		body.get_node("HP").take_dmg(dmg)
