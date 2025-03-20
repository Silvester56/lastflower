extends Node2D

var speed = 10
var damage = 1
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		global_position = global_position + direction * speed

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("getHit"):
		get_parent().increaseXp(body.getHit(damage))
		queue_free()
