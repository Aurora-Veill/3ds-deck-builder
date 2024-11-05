extends Node

var opa = 1
var sens = 1
var deck = Array()
var score = 0
var first = true
var isPaused = false
var roomsEntered = 1
var level = 0
var rooms = [["res://lvl3.tscn","res://Lvl2.tscn", "res://lvl_4.tscn"], [], []]
var bossRoom = [[], [], []]
var levelThresholds = [10, 20, 30]
var PHP = 0
var MHP = 0
func addScore(points):
	score += points

func saveDeck(Deck, Discard):
	deck = Deck + Discard

func saveHP(HP):
	PHP = HP.hp 
	
func saveMaxHP(HP):
	MHP = HP.maxHP

func getNextRoom():
	roomsEntered += 1
	if roomsEntered > levelThresholds[level]:
		level += 1
		return bossRoom[level - 1]
	return rooms[level][randi_range(0, rooms[level].size() - 1)]
