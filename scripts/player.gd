extends CharacterBody2D

var speed = 100.0
var meleePower = 1
var xp: int = 0
var xpForNextLevel: int = 5
var level = 1
var health: int = 100

func _physics_process(delta: float) -> void:
	for body in $Hitbox.get_overlapping_bodies():
		if "isEnemy" in body and body.isEnemy:
			changeHealth(-1)
	if Input.is_action_just_pressed("melee"):
		$Range/Polygon2D.visible = true
		$Range/Timer.start()
		for body in $Range.get_overlapping_bodies():
			if "isEnemy" in body and body.isEnemy:
				increaseXp(body.getHit(meleePower))
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

func changeHealth(ammount):
	health = health + ammount
	$Health.value = health
	if health <= 0:
		$"..".gameover()

func increaseXp(gainedXp: int):
	xp = xp + gainedXp
	if xp >= xpForNextLevel:
		level = level + 1
		xp = xp - xpForNextLevel
		if level < 20:
			xpForNextLevel = xpForNextLevel + 10
		elif level < 40:
			xpForNextLevel = xpForNextLevel + 15
		elif level < 60:
			xpForNextLevel = xpForNextLevel + 20
		$Level.text = "LEVEL " + str(level)
		$Experience.max_value = xpForNextLevel
	$Experience.value = xp

func _on_timer_timeout() -> void:
	$Range/Polygon2D.visible = false
