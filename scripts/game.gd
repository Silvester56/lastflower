extends Node2D

@export var Enemy: PackedScene
@export var Shroom: PackedScene

var rng = RandomNumberGenerator.new()
var percentageOfGame = 0
var shroomDamage = 1

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
		return 160
	if upgradeId == "SHOOTING_POWER":
		return 224
	if upgradeId == "SHOOTING_COOLDOWN":
		return 192
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
	var newEnemy = Enemy.instantiate()
	var spawnAngle = rng.randf_range(0, 2 * PI)
	var spawnRadius = rng.randf_range(600, 800)
	newEnemy.position.x = spawnRadius * cos(spawnAngle)
	newEnemy.position.y = spawnRadius * sin(spawnAngle)
	newEnemy.goal = $Flower.position
	if len(throws) >= 2 and throws[1] == winner:
		newEnemy.setProperties(64, 2, 60, 2)
	if len(throws) >= 3 and throws[2] == winner:
		newEnemy.setProperties(128, 4, 80, 4)
	if len(throws) >= 4 and throws[3] == winner:
		newEnemy.setProperties(196, 8, 100, 8)
	add_child(newEnemy)

func increaseAutoHealSpeed() -> void:
	$Player/AutoHeal.wait_time = $Player/AutoHeal.wait_time - 0.1
	$Flower/AutoHeal.wait_time = $Flower/AutoHeal.wait_time - 0.1

func increaseAutoHealPower() -> void:
	$Player.autoHealPower = $Player.autoHealPower + 1
	$Flower.autoHealPower = $Flower.autoHealPower + 1

func increaseDifficulty(seconds):
	$Spawn.wait_time = 1 - float(seconds) / 2000
	percentageOfGame = float(seconds) / 18
	$Flower.scale.x = 1 + percentageOfGame / 25
	$Flower.scale.y = 1 + percentageOfGame / 25

func gameover():
	$Player/GameOver.show()
	get_tree().paused = true

func increaseShrooms() -> void:
	$ShroomSpawn.start()
	shroomDamage = shroomDamage + 1

func decreaseShroomCooldown() -> void:
	$ShroomSpawn.wait_time = $ShroomSpawn.wait_time - 0.8

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_shroom_spawn_timeout() -> void:
	var shroom = Shroom.instantiate()
	var spawnAngle = rng.randf_range(0, 2 * PI)
	var spawnRadius = rng.randf_range(200, 400)
	shroom.damage = shroomDamage
	shroom.position.x = spawnRadius * cos(spawnAngle)
	shroom.position.y = spawnRadius * sin(spawnAngle)
	add_child(shroom)
