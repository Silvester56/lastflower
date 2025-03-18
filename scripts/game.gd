extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")
var rng = RandomNumberGenerator.new()

func _on_spawn_timeout() -> void:
	var newEnemy = enemy.instantiate()
	var spawnAngle = rng.randf_range(0, 2 * PI)
	var spawnRadius = rng.randf_range(300, 400)
	newEnemy.position.x = spawnRadius * cos(spawnAngle)
	newEnemy.position.y = spawnRadius * sin(spawnAngle)
	newEnemy.goal = $Flower.position
	add_child(newEnemy)
