extends Enemy

var speed = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var target := Node3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var canAttack = true
var projectile = preload("res://projectile.tscn")
var isSlow = false
@onready var nav = $navigator
@onready var atkCD = $AtkCooldown
signal onDeath(x, y, z)

func _ready():
	$SpawnNoise.play()
	$slowModel.set_visible(false)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var direction = Vector3.ZERO
	move_and_slide()
	if !target:
		return
	if position.distance_to(target.global_position) < 25:
		if position.distance_to(target.global_position) < 10:
			nav.set_target_position(Vector3(randi(), position.y, randi()))
		if canAttack:
			atkCD.start()
			attack(projectile)
			canAttack = false
	else:
		nav.set_target_position(target.global_position)
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * speed, delta)
	if isSlow:
		velocity = velocity.lerp(direction * speed * 0.5, delta)
	
func attack(Projectile: PackedScene) -> void:
	$AtkNoise.play()
	var atk = Projectile.instantiate()
	atk.position = position
	atk.set_dir((target.position - position).normalized(), false)
	atk.maker = self
	get_parent().add_child(atk)
		
func _on_hp_on_death():
	onDeath.emit(position)
	queue_free() # Replace with function body.

func take_slow(time):
	$slowTimer.start(time)
	isSlow = true
	$regModel.set_visible(false)
	$slowModel.set_visible(true)
	
func _on_slow_timer_timeout():
	isSlow = false
	$regModel.set_visible(true)
	$slowModel.set_visible(false)

func _on_atk_cooldown_timeout():
	canAttack = true # Replace with function body.
