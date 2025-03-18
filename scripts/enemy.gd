extends CharacterBody2D

var goal: Vector2
var speed = 50.0

func _physics_process(delta: float) -> void:
	var direction = (goal - position).normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)

func _on_timer_timeout() -> void:
	$Sprite2D.frame = ($Sprite2D.frame + 1) % 2
