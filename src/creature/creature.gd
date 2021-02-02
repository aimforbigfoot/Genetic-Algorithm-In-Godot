extends Area2D

var original := false
var dead := false
var alive := false
var speed := 20
var genome := []
var spotInGenome := 0
var fitness := 0.0
var goal : Area2D
var genomeSize := 75
var mutAmt := 0.05

func _ready() -> void:
	for i in genomeSize:
#		print(i)
		genome.append(Vector2.ZERO)
	randomize()
	goal = get_parent().get_parent().get_node("goal")
	if Global.bestFit < 500:
		mutAmt = 0.01
	if Global.bestDNA == null: #original person
		for i in genomeSize:
			var v := Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*speed
			genome[i] = v
	
	else: #second gen smth gen
		for i in genomeSize:
			if randf() < mutAmt:
				var v := Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()*speed
				genome[i] = v #mutate that gene
			else:
				genome[i] = Global.bestDNA[i] # keep the same gene

func _on_Timer_timeout() -> void:
	if alive:
		spotInGenome += 1
	else:
		dead = true
#		print(fitness)


func _physics_process(_delta: float) -> void:
	if alive:
		if !dead and spotInGenome < genome.size():
			global_position += genome[spotInGenome]
		else:
			die()


func die() -> void:
	dead = true
	fitness = ((global_position.distance_squared_to(goal.global_position)))



func _on_creature_body_entered(body: Node) -> void:
	if body:
		dead = true

func _on_creature_area_entered(area: Area2D) -> void:
	if area.is_in_group("goal"):
		die()
