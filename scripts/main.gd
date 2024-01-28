extends Node2D

var Enemy = preload("res://scenes/enemy.tscn")
var Pickup = preload("res://scenes/items/pickable.tscn")

@onready var enemy_container = $EnemyContainer
@onready var pickup_container = $PickupContainer
@onready var spawn_container = $Player/CharacterBody2D/SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var item_timer = $ItemTimer
@onready var difficulty_timer = $DifficultyTimer
@onready var bullet_manager = $BulletManager
@onready var player = $Player

@onready var pun1 = $CanvasLayer/VBoxContainer/PunRow

@onready var difficulty_value = $CanvasLayer/VBoxContainer/BottomRow/HBoxContainer/DifficultyValue
@onready var killed_value = $CanvasLayer/VBoxContainer/TopRow2/TopRow/EnemiesKilledValue
@onready var game_over_screen = $CanvasLayer/GameOverScreen

var active_pun = null
var current_letter_index: int = -1

var difficulty: int = 0
var enemies_killed: int = 0

func _ready() -> void:
	start_game()
	GlobalSignals.connect("game_over", Callable(self, "game_over"))
	GlobalSignals.connect("killed", Callable(self, "increase_killcount"))
	
func increase_killcount(): 
	enemies_killed += 1
	killed_value.text = str(enemies_killed)
	
func find_new_prompt(typed_character: String, puns) -> bool:
	var prompt = puns.get_prompt()
	var next_character = prompt.substr(0, 1)
	if next_character == typed_character.to_upper():
		active_pun = puns
		current_letter_index = 1
		active_pun.set_next_character(current_letter_index)
		return true
	else:
		return false

func player_typed(key_typed: String):
	var prompt = active_pun.get_prompt()
	var next_character = prompt.substr(current_letter_index, 1)
	if key_typed.to_upper() == next_character:
		print("successfully typed %s" % key_typed)
		GlobalSignals.emit_signal("shoot")
		current_letter_index += 1
		active_pun.set_next_character(current_letter_index)
		if current_letter_index == prompt.length():
			current_letter_index = -1
			active_pun.init_prompt()
			active_pun = null

	else:
		print("incorrectly typed %s instead of %s" % [key_typed, next_character])
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		GlobalSignals.emit_signal("player_typed")

		if active_pun == null:
			find_new_prompt(key_typed, pun1)
		else:
			player_typed(key_typed)

func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()

func spawn_enemy():
	var enemy_instance = Enemy.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)
	enemy_instance.set_difficulty(difficulty)
	
func spawn_items():
	var pickup = Pickup.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	pickup.global_position = spawns[index].global_position
	pickup.type = 'speed'
	pickup_container.add_child(pickup)
	
func _on_item_timer_timeout():
	print('SPAWN ITEM')
	spawn_items()

func _on_DifficultyTimer_timeout() -> void:
	difficulty += 1
	GlobalSignals.emit_signal("difficulty_increased", difficulty)
	print("Difficulty increased to %d" % difficulty)
	var new_wait_time = spawn_timer.wait_time - 0.2
	spawn_timer.wait_time = clamp(new_wait_time, 1, spawn_timer.wait_time)
	difficulty_value.text = str(difficulty)

func game_over():
	game_over_screen.show()
	
	spawn_timer.stop()
	difficulty_timer.stop()
	item_timer.stop()
	
	active_pun = null
	current_letter_index = -1
	
	for enemy in enemy_container.get_children():
		enemy.queue_free()

func start_game():
	randomize()
		
	pun1.init_prompt()

	difficulty = 0
	enemies_killed = 0
	difficulty_value.text = str(0)
	killed_value.text = str(0)

	spawn_timer.start()
	difficulty_timer.start()
	item_timer.start()
	
	spawn_enemy()
	
	GlobalSignals.emit_signal("game_started")
	game_over_screen.hide()
	
func get_is_game_started() -> bool:
	return current_letter_index != -1
	
func _on_RestartButton_pressed() -> void:
	start_game()

