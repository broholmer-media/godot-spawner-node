extends Node2D

class_name Spawner2D

onready var pos = $Position2D

var rng = RandomNumberGenerator.new()

var enemy = preload("res://Enemy.tscn")

var enemy_dict = {
	"Blue": preload("res://Enemy.tscn"),
	"Green": preload("res://Enemy2.tscn"),
	"Red": preload("res://Enemy3.tscn")
}

var group_1 = [
	enemy_dict["Green"],
	enemy_dict["Blue"],
	enemy_dict["Blue"],
	enemy_dict["Red"],
	enemy_dict["Green"]
]



func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		spawn_r_delay_rand_array(group_1, pos.global_position, 0.5,2.0,2,true,true)
#		spawn(group_1,pos.global_position,2,true,0.5,2.5,true, true, false, true)


func spawn(to_spawn, spawn_position:Vector2, spawn_amount:int, is_timed:bool, default_time:float, min_time:float, max_time:float, is_random_time:bool, is_random_time_per_spawn:bool, is_random_order:bool):
## Length of Spawn Timer	
	var spawn_time:float
	if !is_timed:
		spawn_time = 0.0
	else:
		if is_random_time:
			rng.randomize()
			spawn_time = rng.randf_range(min_time,max_time)
		else:
			spawn_time = default_time

	## BEGIN SPAWN LOOP
# warning-ignore:unused_variable
	for i in range(spawn_amount):
		if typeof(to_spawn) == TYPE_ARRAY:
			if is_random_order:
				randomize()
				to_spawn.shuffle()
			if is_random_time_per_spawn:
				for s in to_spawn:
					rng.randomize()
					spawn_time = rng.randf_range(min_time, max_time)
					yield(get_tree().create_timer(spawn_time),"timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position
			else:
				for s in to_spawn:
					yield(get_tree().create_timer(spawn_time),"timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position
		else:
			if is_random_time_per_spawn:
				rng.randomize()
				spawn_time = rng.randf_range(min_time, max_time)
			yield(get_tree().create_timer(spawn_time),"timeout")
			var new_spawn = to_spawn.instance()
			add_child(new_spawn)
			new_spawn.global_position = spawn_position

## FIXED DELAY SPAWNERS

## SPAWNS INDIVIDUAL INSTANCES
func spawn_indi(to_spawn, spawn_position:Vector2, spawn_delay:float, spawn_amount:int):
	for i in spawn_amount:
		yield(get_tree().create_timer(spawn_delay), "timeout")
		var new_spawn = to_spawn.instance()
		add_child(new_spawn)
		new_spawn.global_position = spawn_position

## SPAWNS AN ARRAY OF INSTANCES
func spawn_fixed_array(to_spawn:Array, spawn_position:Vector2, spawn_delay:float, spawn_amount:int):
	for i in spawn_amount:
		for s in to_spawn:
			yield(get_tree().create_timer(spawn_delay), "timeout")
			var new_spawn = s.instance()
			add_child(new_spawn)
			new_spawn.global_position = spawn_position

## RANDOMIZES AN ARRAY BEFORE SPAWNING
func spawn_rand_array(to_spawn:Array, spawn_position:Vector2, spawn_delay:float, spawn_amount:int, random_per_spawn:bool):
	## RANDOM PER SPAWN RANDOMIZES ARRAY EACH SPAWNING ITERATION
	if random_per_spawn:
		for i in spawn_amount:
			randomize()
			to_spawn.shuffle()
			for s in to_spawn:
				yield(get_tree().create_timer(spawn_delay), "timeout")
				var new_spawn = s.instance()
				add_child(new_spawn)
				new_spawn.global_position = spawn_position
	else:
		randomize()
		to_spawn.shuffle()
		for i in spawn_amount:
			for s in to_spawn:
				yield(get_tree().create_timer(spawn_delay), "timeout")
				var new_spawn = s.instance()
				add_child(new_spawn)
				new_spawn.global_position = spawn_position



## RANDOM DELAY SPAWNERS

##SPAWNS INDIVIDUAL
func spawn_r_delay_indi(to_spawn, spawn_position:Vector2, min_time:float, max_time:float, spawn_amount:int, rand_time_per_spawn:bool):
	if rand_time_per_spawn:
		for i in spawn_amount:
			yield(get_tree().create_timer(random_time(min_time, max_time)),"timeout")
			var new_spawn = to_spawn.instance()
			add_child(new_spawn)
			new_spawn.global_position = spawn_position
	else:
		var rand_time = random_time(min_time, max_time)
		for i in spawn_amount:
			yield(get_tree().create_timer(rand_time), "timeout")
			var new_spawn = to_spawn.instance()
			add_child(new_spawn)
			new_spawn.global_position = spawn_position	

##SPAWNS SET ARRAY
func spawn_r_delay_fixed_array(to_spawn:Array, spawn_position:Vector2, min_time:float, max_time:float, spawn_amount:int, rand_time_per_spawn:bool):
	if rand_time_per_spawn:
		for i in spawn_amount:
			for s in to_spawn:
				yield(get_tree().create_timer(random_time(min_time, max_time)),"timeout")
				var new_spawn = s.instance()
				add_child(new_spawn)
				new_spawn.global_position = spawn_position
	else:
		var rand_time = random_time(min_time, max_time)
		for i in spawn_amount:
			for s in to_spawn:
				yield(get_tree().create_timer(rand_time), "timeout")
				var new_spawn = s.instance()
				add_child(new_spawn)
				new_spawn.global_position = spawn_position

## RANDOMIZES ARRAY BEFORE SPAWNING
func spawn_r_delay_rand_array(to_spawn:Array, spawn_position:Vector2, min_time:float, max_time:float, spawn_amount:int, rand_order_per_spawn:bool, rand_time_per_spawn:bool):
	if rand_order_per_spawn:
		if rand_time_per_spawn:
			for i in spawn_amount:
				##RANDOMIZES ARRAY
				randomize()
				to_spawn.shuffle()
				for s in to_spawn:
					yield(get_tree().create_timer(random_time(min_time, max_time)), "timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position
		else:
			var rand_time = random_time(min_time, max_time)
			for i in spawn_amount:
				randomize()
				to_spawn.shuffle()
				for s in to_spawn:
					yield(get_tree().create_timer(rand_time), "timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position
				
	else:
		randomize()
		to_spawn.shuffle()
		if rand_time_per_spawn:
			for i in spawn_amount:
				for s in to_spawn:
					yield(get_tree().create_timer(random_time(min_time, max_time)), "timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position
		else:
			var rand_time = random_time(min_time, max_time)
			for i in spawn_amount:
				for s in to_spawn:
					yield(get_tree().create_timer(rand_time), "timeout")
					var new_spawn = s.instance()
					add_child(new_spawn)
					new_spawn.global_position = spawn_position

func random_time(min_time:float, max_time:float):
	rng.randomize()
	var rand_time = rng.randf_range(min_time, max_time)
	return rand_time
