extends Control

@export var dmgCurve: Curve
@export var PC: Node
@export var EnemySpawner : Node
@onready var PCHP = PC.getHPNode()
@onready var blood = $"Fullscreen Effects/Blood"
@onready var globals = get_node("/root/GlobalVars")
@onready var HPBar = $"Fullscreen Effects/HPBar"
@onready var Health = $"Fullscreen Effects/HPBar/Health"
@onready var enemyCounter = $"Fullscreen Effects/EnemLeft"
var isPaused = false
var dmgVal = 0

func _ready():
	$PauseMenu.hide()
	$PauseMenu/VBoxContainer/opaLabel.set_text("Opacity - " + str(globals.opa * 100) + "%")
	$PauseMenu/VBoxContainer/sensLabel.set_text("Sensitivity - " + str(globals.sens * 100) + "%")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (blood):
		blood.self_modulate.a = dmgCurve.sample(1 - float(PCHP.hp)/PCHP.maxHP) * get_node("/root/GlobalVars").opa
	if HPBar:
		HPBar.size.x = float(PCHP.hp)/PCHP.maxHP * $"Fullscreen Effects/HPBar2".get_size().x
		if Health:
			Health.set_frame(PCHP.hp - 1)
	if enemyCounter:
		enemyCounter.set_text("Enemies Left: " + str(EnemySpawner.curEnems))

func pauseMenu():
	if isPaused:
		Engine.time_scale = 1
		$PauseMenu.hide()
		get_node("/root/GlobalVars").isPaused = false
	else:
		Engine.time_scale = 0
		$PauseMenu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	isPaused = !isPaused
	get_node("/root/GlobalVars").isPaused = isPaused

func _on_resume_pressed():
	pauseMenu()


func _on_quit_pressed():
	get_tree().quit()

func pickup_in_range(cardName):
	$"Fullscreen Effects/Pickup".set_text("Press " + InputMap.action_get_events("collect_card")[0].as_text() + " to pick up " + cardName)
	$"Fullscreen Effects/Pickup".set_visible(true)

func pickup_left_range():
	$"Fullscreen Effects/Pickup".set_visible(false)

func _on_opa_slider_value_changed(value):
	globals.opa = value
	$PauseMenu/VBoxContainer/opaLabel.set_text("Opacity - " + str(globals.opa * 100) + "%")


func _on_sens_slider_value_changed(value):
	globals.sens = value
	$PauseMenu/VBoxContainer/sensLabel.set_text("Sensitivity - " + str(globals.sens * 100) + "%")


func _on_pc_reloading_a():
	$Cards/Control.PCreloadA()


func _on_pc_reloading_s():
	$Cards/Control.PCreloadS()


func _on_pc_re_ad():
	$Cards/Control.PCreAD()


func _on_pc_re_sd():
	$Cards/Control.PCreSD()
