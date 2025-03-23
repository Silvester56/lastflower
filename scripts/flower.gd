extends Area2D

var health: int = 200
var autoHealPower: int = 2
var thorns = false
var thornsChance = 5
var thornsPower = 1
var rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if "isEnemy" in body and body.isEnemy:
			changeHealth(-1)

func changeHealth(ammount):
	if health + ammount > 200:
		health = 200
	else:
		health = health + ammount
	$Health.value = health
	if health <= 0:
		$"..".gameover()

func increaseThorns() -> void:
	thorns = true
	thornsChance = thornsChance + 5
	$Thorns.show()

func increaseThornsPower() -> void:
	thornsPower = thornsPower + 1

func _on_auto_heal_timeout() -> void:
	changeHealth(autoHealPower)

func _on_body_entered(body: Node2D) -> void:
	if thorns and body.has_method("getHit") and rng.randf_range(0, 100) < thornsChance:
		$"../Player".increaseXp(body.getHit(thornsPower))
