extends Node2D

@onready var enemy = preload("res://scenes/enemy.tscn")
var rng = RandomNumberGenerator.new()
var globalAutoHealSpeed = 1
var globalAutoHealPower = 1
var percentageOfGame = 0

func getUpgradeOffest(upgradeId: String) -> int:
	if upgradeId == "AUTO_HEAL_SPEED":
		return 0
	if upgradeId == "AUTO_HEAL_POWER":
		return 64
	if upgradeId == "MELEE_COOLDOWN":
		return 32
	if upgradeId == "SHROOMS":
		return 96
	if upgradeId == "THORNS":
		return 128
	if upgradeId == "SHOOTING_WEAPON":
		return 0
	if upgradeId == "SHOOTING_POWER":
		return 0
	if upgradeId == "SHOOTING_COOLDOWN":
		return 0
	return 0

func _on_spawn_timeout() -> void:
	var throws = []
	throws.push_back(rng.randf_range(0, 100))
	if percentageOfGame > 3:
		throws.push_back(rng.randf_range(0, min(100, 30 + percentageOfGame)))
	if percentageOfGame > 10:
		throws.push_back(rng.randf_range(0, min(100, 10 + percentageOfGame)))
	if percentageOfGame > 25:
		throws.push_back(rng.randf_range(0, min(100, percentageOfGame)))
	var winner = throws.max()
	var newEnemy = enemy.instantiate()
	var spawnAngle = rng.randf_range(0, 2 * PI)
	var spawnRadius = rng.randf_range(600, 800)
	newEnemy.position.x = spawnRadius * cos(spawnAngle)
	newEnemy.position.y = spawnRadius * sin(spawnAngle)
	newEnemy.goal = $Flower.position
	if len(throws) == 2 and throws[1] == winner:
		newEnemy.setProperties(64, 2, 60, 2)
	if len(throws) == 3 and throws[2] == winner:
		newEnemy.setProperties(96, 5, 80, 4)
	if len(throws) == 4 and throws[3] == winner:
		newEnemy.setProperties(128, 10, 100, 8)
	add_child(newEnemy)

func increaseAutoHealSpeed() -> void:
	globalAutoHealSpeed = globalAutoHealSpeed - 0.1
	$Player/AutoHeal.wait_time = globalAutoHealSpeed
	$Flower/AutoHeal.wait_time = globalAutoHealSpeed

func increaseAutoHealPower() -> void:
	globalAutoHealPower = globalAutoHealPower + 1
	$Player.autoHealPower = globalAutoHealPower
	$Flower.autoHealPower = globalAutoHealPower

func increaseDifficulty(seconds):
	$Spawn.wait_time = 1 - float(seconds) / 2000
	percentageOfGame = seconds / 18

func gameover():
	$Player/GameOver.show()
	get_tree().paused = true

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
