extends Area2D

var health: int = 100
var autoHealPower: int = 1

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if "isEnemy" in body and body.isEnemy:
			changeHealth(-1)

func changeHealth(ammount):
	health = health + ammount
	$Health.value = health
	if health <= 0:
		$"..".gameover()

func _on_auto_heal_timeout() -> void:
	changeHealth(autoHealPower)
