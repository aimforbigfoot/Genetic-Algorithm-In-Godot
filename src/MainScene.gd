extends Node2D

onready var cFolder := $creatureFolder
onready var goal := $goal
export var spawnAmt := 100



func _ready() -> void:
	print("We are on gen: "+str(Global.generationNum))
	randomize()
	spawnFunc()


func spawnFunc() -> void:
	if Global.bestDNA:
		for i in spawnAmt:
			var creature := preload("res://src/creature/creature.tscn").instance()
			creature.original = false
			cFolder.add_child(creature)
		for creature in cFolder.get_children():
			creature.alive = true
			creature.dead = false
	else: # 
		for i in spawnAmt:
			var creature := preload("res://src/creature/creature.tscn").instance()
			creature.original = true
			creature.alive = true
			cFolder.add_child(creature)
			



func _on_Timer_timeout() -> void:
	var deadAmt := 0.0
	for creature in cFolder.get_children():
		if creature.dead:
			deadAmt += 1
	if deadAmt == spawnAmt: # everyone is dead
#		check for closest person to goal and their fitness
		var bestFitnessSoFar := 10000000
		var idOfMin := 0
#		find the best fitness
		for i in cFolder.get_child_count():
			var fittness :float= cFolder.get_child(i).fitness
			if fittness < bestFitnessSoFar:
				idOfMin = i
				bestFitnessSoFar = fittness
#		get the best fitness and save it, then reload scene
		if Global.bestFit > bestFitnessSoFar:
			Global.bestFit = bestFitnessSoFar
			Global.bestDNA = cFolder.get_child(idOfMin).genome 
		Global.generationNum += 1
		get_tree().reload_current_scene()



