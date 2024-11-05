extends card
var proj = preload("res://projectile.tscn")

func use(Player):
	var atk = proj.instantiate()
	atk.position = Player.shootPos()
	atk.position += -Player.cameraf.get_global_transform().basis.z 
	atk.set_dir(-Player.cameraf.get_global_transform().basis.z, true)
	atk.maker = Player
	Player.get_parent().add_child(atk)
