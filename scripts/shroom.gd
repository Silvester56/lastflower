extends Area2D

var damage = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("getHit"):
		$"../Player".increaseXp(body.getHit(damage))
		queue_free()
