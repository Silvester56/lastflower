extends Area2D

@export var Shroom: PackedScene

var health: int = 100
var autoHealPower: int = 1
var thorns = false
var shrooms = false
var thornsChance = 5
var shroomDamage = 1
var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if "isEnemy" in body and body.isEnemy:
			changeHealth(-1)

func changeHealth(ammount):
	health = health + ammount
	$Health.value = health
	if health <= 0:
		$"..".gameover()

func increaseThorns() -> void:
	thorns = true
	thornsChance = thornsChance + 5
	$Thorns.show()

func increaseShrooms() -> void:
	$ShroomSpawn.start()
	shroomDamage = shroomDamage + 1

func _on_auto_heal_timeout() -> void:
	changeHealth(autoHealPower)

func _on_body_entered(body: Node2D) -> void:
	if thorns and body.has_method("getHit") and rng.randf_range(0, 100) < thornsChance:
		$"../Player".increaseXp(body.getHit(1))

func _on_shroom_spawn_timeout() -> void:
	var shroom = Shroom.instantiate()
	var spawnAngle = rng.randf_range(0, 2 * PI)
	var spawnRadius = rng.randf_range(200, 400)
	shroom.damage = shroomDamage
	shroom.position.x = spawnRadius * cos(spawnAngle)
	shroom.position.y = spawnRadius * sin(spawnAngle)
	add_child(shroom)
