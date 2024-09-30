extends Node

var opa = 1
var sens = 1
var deck = Array()
var score = 0
var first = true
var isPaused = false
var roomsEntered = 1
var level = 0
var rooms = [["res://Lvl1.tscn","res://lvl3.tscn","res://Lvl2.tscn"], [], []]
var bossRoom = [[], [], []]
var levelThresholds = [10, 20, 30]
func addScore(points):
	score += points

func saveDeck(Deck, Discard):
	deck = Deck + Discard

func getNextRoom():
	roomsEntered += 1
	if roomsEntered > levelThresholds[level]:
		level += 1
		return bossRoom[level - 1]
	return rooms[level][randi_range(0, rooms[level].size() - 1)]
