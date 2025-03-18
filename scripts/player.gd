extends CharacterBody2D

var speed = 100.0
var meleePower = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("melee"):
		$Range/Polygon2D.visible = true
		$Range/Timer.start()
		for body in $Range.get_overlapping_bodies():
			if "isEnemy" in body and body.isEnemy:
				body.getHit(meleePower)
	var directionX := Input.get_axis("left", "right")
	if directionX:
		velocity.x = directionX * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var directionY := Input.get_axis("up", "down")
	if directionY:
		velocity.y = directionY * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	move_and_slide()

func _on_timer_timeout() -> void:
	$Range/Polygon2D.visible = false
