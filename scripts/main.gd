extends Node2D

var Enemy = preload("res://scenes/enemy.tscn")

@onready var enemy_container = $EnemyContainer
@onready var spawn_container = $Player/CharacterBody2D/SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer
@onready var bullet_manager = $BulletManager
@onready var player = $Player

@onready var pun1 = $CanvasLayer/VBoxContainer/PunRow

@onready var difficulty_value = $CanvasLayer/VBoxContainer/BottomRow/HBoxContainer/DifficultyValue
@onready var killed_value = $CanvasLayer/VBoxContainer/TopRow2/TopRow/EnemiesKilledValue
@onready var game_over_screen = $CanvasLayer/GameOverScreen


var active_enemy = null
var current_letter_index: int = -1

var difficulty: int = 0
var enemies_killed: int = 0

func _ready() -> void:
	start_game()
	pun1.init_prompt()
	GlobalSignals.connect("game_over", Callable(self, "game_over"))


func find_new_active_enemy(typed_character: String):
	if found_new_active_enemy(typed_character, pun1):
		return


func found_new_active_enemy(typed_character: String, enemy) -> bool:
	var prompt = enemy.get_prompt()
	var next_character = prompt.substr(0, 1)
	if next_character == typed_character.to_upper():
		print("found new enemy that starts with %s" % next_character)
		active_enemy = enemy
		current_letter_index = 1
		active_enemy.set_next_character(current_letter_index)
		return true
	else:
		return false


func player_typed(key_typed: String):
	var prompt = active_enemy.get_prompt()
	var next_character = prompt.substr(current_letter_index, 1)
	if key_typed.to_upper() == next_character:
		print("successfully typed %s" % key_typed)
		GlobalSignals.emit_signal("shoot")
		current_letter_index += 1
		active_enemy.set_next_character(current_letter_index)
		if current_letter_index == prompt.length():
			print("done")
			current_letter_index = -1
			active_enemy.init_prompt()
			active_enemy = null
			enemies_killed += 1
			killed_value.text = str(enemies_killed)
	else:
		print("incorrectly typed %s instead of %s" % [key_typed, next_character])
		


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()

		if active_enemy == null:
			find_new_active_enemy(key_typed)
		else:
			player_typed(key_typed)


func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()


func spawn_enemy():
	var enemy_instance = Enemy.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_instance.global_position = spawns[index].global_position
	add_child(enemy_instance)
	enemy_instance.set_difficulty(difficulty)


func _on_DifficultyTimer_timeout() -> void:
	if difficulty >= 20:
		difficulty_timer.stop()
		difficulty = 20
		return

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
	active_enemy = null
	current_letter_index = -1
	for enemy in enemy_container.get_children():
		enemy.queue_free()


func start_game():
	game_over_screen.hide()
	difficulty = 0
	enemies_killed = 0
	difficulty_value.text = str(0)
	killed_value.text = str(0)
	randomize()
	spawn_timer.start()
	difficulty_timer.start()
	spawn_enemy()


func _on_RestartButton_pressed() -> void:
	start_game()
