extends CharacterBody3D
class_name player

@export var BobCurve: Curve
var speed = 7.0
var jump_height = 9
signal take_dmg
signal reloading
signal relD
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cameraf = $fpv
@onready var global = get_node("/root/GlobalVars")
@export var UI : Control
var deck = Array()
var disc = Array()
var leftHand
var rightHand
var hasDashed = false
var objTarget = Vector3.ZERO
var objActive = false
var canShoot = true
var canSpec = true
var tilShufAtk = 0
var tilShufSpec = 0
var Cycle100 = 0.0
var Jumping = false

func _ready():
	if !global.first:
		deck = global.deck
		deck.shuffle()
		$HP.hp = global.PHP
		$HP.maxHP = global.MHP
	else:
		var bolt = preload("res://default_proj_card.tscn")
		deck.append(bolt.instantiate())
		deck.append(bolt.instantiate())
		deck.append(bolt.instantiate())
	leftHand = deck[0]
	deck.remove_at(0)
	rightHand = deck[0]
	deck.remove_at(0)

func _process(_delta):
	if !UI.isPaused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if objActive:
		$rotater/objPointer.set_visible(true)
		$rotater/objPointer.look_at(objTarget)
	else:
		$rotater/objPointer.set_visible(false)
	if not is_on_floor():
		if hasDashed:
			velocity.y -= gravity * delta * 3
		velocity.y -= gravity * delta
	else:
		hasDashed = false
		Jumping = false
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
		Jumping = true
	if Input.is_action_just_released("jump"):
		velocity.y = min(velocity.y, 0)
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !$MoveNoise.playing:
			$MoveNoise.play()
		if abs(velocity.x) < speed:
			velocity.x = direction.x * speed
		if abs(velocity.z) < speed:
			velocity.z = direction.z * speed
		if is_on_floor():
			Cycle100 += delta * 100
			if Cycle100 > 100:
				Cycle100 = 0.0
			$fpv.position.y = (BobCurve.sample(Cycle100 / 100)) * .5
			$rotater.position.y = (BobCurve.sample(Cycle100 / 100)) * .5
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	if Input.is_action_pressed("use_atk") and !get_node("../UI").isPaused and canShoot:
		if !leftHand:
			return
		canShoot = false
		if !leftHand.has_method("use"):
			return
		leftHand.use(self)
		if leftHand.fragile:
			leftHand.queue_free()
		else:
			disc.append(leftHand)
		if deck.size() <= 0:
			deck = disc
			deck.shuffle()
			disc = Array()
			$shootTimer.start(max(0.2 * deck.size(), 0.6))
			reloading.emit()
		else:
			$shootTimer.start(leftHand.recharge)
		leftHand = deck[0]
		deck.remove_at(0)
	
	if Input.is_action_pressed("use_spec") and !get_node("../UI").isPaused and canShoot:
		if !rightHand:
			return
		canShoot = false
		if !rightHand.has_method("use"):
			return
		rightHand.use(self)
		if rightHand.fragile:
			rightHand.queue_free()
		else:
			disc.append(rightHand)
		if deck.size() <= 0:
			deck = disc
			deck.shuffle()
			disc = Array()
			$shootTimer.start(max(0.2 * deck.size(), 0.6))
			reloading.emit()
		else:
			$shootTimer.start(rightHand.recharge)
		rightHand = deck[0]
		deck.remove_at(0)
		
	if Input.is_action_just_pressed("collect_card") and !get_node("../UI").isPaused:
		if $"../UpgradeSpawner".cloCard:
			$"../UpgradeSpawner".cloCard.collect(self)
			$"../UpgradeSpawner".cloCard = null

	if velocity.y > jump_height:
		hasDashed = true
	if abs(velocity.x) > speed or abs(velocity.z) > speed or velocity.y > jump_height:
		if is_on_floor():
			velocity /= 1.1
		velocity /= 1.1
func _input(event):
	if event is InputEventMouseMotion and !get_node("../UI").isPaused:
		rotation.y -= (event.relative.x * global.sens) / 100
		cameraf.rotation.x -= (event.relative.y * global.sens) / 250
		$rotater.rotation.x -= (event.relative.y * global.sens) / 250
		
func attack(Projectile: PackedScene) -> void:
	$ShootNoise.play()
	var atk = Projectile.instantiate()
	atk.position = $fpv.position
	atk.set_dir(-cameraf.get_global_transform().basis.z, true)
	atk.maker = self
	atk.speed = 1
	get_parent().add_child(atk)

func addCard(Card, Pickup):
	deck.insert(randi_range(0, max(deck.size() - 1, 0)),Card.instantiate())
	Pickup.queue_free()

func _on_hp_on_death():
	get_tree().change_scene_to_file("res://Lvl2.tscn")

func _on_hp_take_dmg():
	$DmgNoise.play()
	take_dmg.emit()

func getHPNode():
	return $HP

func _on_shoot_timer_timeout():
	canShoot = true # Replace with function body.
	relD.emit()

func take_slow(time):
	$slowTimer.start(time)
	speed /= 2

func _on_slow_timer_timeout():
	speed *= 2

func shootPos():
	return $fpv.global_position

func player():
	pass
