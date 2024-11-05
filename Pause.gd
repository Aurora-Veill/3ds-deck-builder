extends Node3D

@onready var UI = $UI
var endPortal = preload("res://end_portal.tscn")
@export var ePLoc = Vector3(0, 2.5, 0)
@export var PC : player
var nextLvl
# Called when the node enters the scene tree for the first time.
func _ready():
	nextLvl = get_node("/root/GlobalVars").getNextRoom()

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		
		UI.pauseMenu()

func spawnEnd():
	var portal = endPortal.instantiate()
	portal.position = ePLoc
	portal.entered.connect(start_next_lvl)
	portal.player = PC
	portal.look()
	add_child(portal)
	

func start_next_lvl():
	PC.deck.append(PC.leftHand) 
	PC.deck.append(PC.rightHand)
	get_node("/root/GlobalVars").saveDeck(PC.deck, PC.disc)
	get_node("/root/GlobalVars").saveHP(PC.getHPNode())
	get_node("/root/GlobalVars").saveMaxHP(PC.getHPNode())
	get_node("/root/GlobalVars").first = false
	get_tree().change_scene_to_file(nextLvl)
