extends card
var PC
var timer

func use(Player):
	PC = Player
	var HP = PC.getHPNode()
	if HP.hp < HP.maxHP:
		HP.heal(3)
