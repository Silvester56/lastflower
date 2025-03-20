extends CharacterBody2D

var goal: Vector2
var speed = 50.0
var isEnemy = true
var health: int = 1
var xpDropped = 1

func _physics_process(delta: float) -> void:
	var direction = (goal - position).normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)

func getHit(damage: int):
	health = health - damage
	if health <= 0:
		queue_free()
		return xpDropped
	return 0

func setProperties(yOffsset, h, s, xp) -> void:
	$Sprite2D.region_rect = Rect2(0, yOffsset, 128, 64)
	health = h
	speed = s
	xpDropped = xp

func _on_timer_timeout() -> void:
	$Sprite2D.frame = ($Sprite2D.frame + 1) % 2
