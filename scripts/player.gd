extends CharacterBody2D

@export var UpgradePurchased: PackedScene
@export var Bullet: PackedScene

var speed = 100.0
var meleePower = 1
var shootingPower = 1
var xp: int = 0
var xpForNextLevel: int = 5
var level = 1
var health: int = 100
var autoHealPower: int = 2
var weapon = 0
var purchasedUpgrades = {}
var seconds = 0
var minutes = 0

func _physics_process(delta: float) -> void:
	for body in $Hitbox.get_overlapping_bodies():
		if "isEnemy" in body and body.isEnemy:
			changeHealth(-1)
	if weapon > 0 and Input.is_action_just_pressed("shoot") and $ShootingCooldown.is_stopped():
		$ShootingCooldown.start()
		$ShootingSFX.play()
		var angles = [0]
		if weapon == 2:
			angles = [0, 0.3, -0.3]
		if weapon == 3:
			angles = [0, 0.3, -0.3, 0.6, -0.6]
		if weapon == 4:
			angles = [0, 7 * PI / 4, 3 * PI / 2, 5 * PI / 4, PI, 3 * PI / 4, PI / 2, PI / 4]
		if weapon == 5:
			angles = [0, 15 * PI / 8, 14 * PI / 8, 13 * PI / 8, 3 * PI / 2, 11 * PI / 8, 5 * PI / 4, 9 * PI / 8, PI, 7 * PI / 8, 3 * PI / 4, 5 * PI / 8, PI / 2, 3 * PI / 8, PI / 4, PI / 8]
		for a in angles:
			var bullet = Bullet.instantiate()
			var target = get_global_mouse_position()
			bullet.direction = global_position.direction_to(target).normalized().rotated(a)
			bullet.damage = shootingPower
			add_child(bullet)
	if Input.is_action_just_pressed("pause"):
		$PauseMenu.show()
		get_tree().paused = true
	if Input.is_action_just_pressed("melee") and $MeleeCooldown.is_stopped():
		$Range/Polygon2D.visible = true
		$Range/Timer.start()
		$MeleeCooldown.start()
		$MeleeSFX.play()
		for body in $Range.get_overlapping_bodies():
			if body.has_method("getHit"):
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
	if health + ammount > 100:
		health = 100
	else:
		health = health + ammount
	$Health.value = health
	if health <= 0:
		$"..".gameover()

func displayUpgrade(upgradeIdentifier):
	var upgrade
	if upgradeIdentifier in purchasedUpgrades:
		purchasedUpgrades[upgradeIdentifier] = purchasedUpgrades[upgradeIdentifier] + 1
	else:
		purchasedUpgrades[upgradeIdentifier] = 1
	for c in $UpgradeDisplay.get_children():
		c.queue_free()
	for key in purchasedUpgrades.keys():
		upgrade = UpgradePurchased.instantiate()
		upgrade.setProperties($"..".getUpgradeOffest(key), purchasedUpgrades[key])
		$UpgradeDisplay.add_child(upgrade)

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
		if len($UpgradeManager.allUpgrades.keys()) > 0:
			$UpgradeManager.onLevelUp(level)
	$Experience.value = xp

func decreaseMeleeCooldown() -> void:
	$MeleeCooldown.wait_time = $MeleeCooldown.wait_time - 0.1

func increaseMeleePower() -> void:
	meleePower = meleePower + 1

func decreaseShootingCooldown() -> void:
	$ShootingCooldown.wait_time = $ShootingCooldown.wait_time - 0.1

func increaseSpeed() -> void:
	speed = speed + 10

func increaseShootingPower() -> void:
	shootingPower = shootingPower + 1

func nextWeapon() -> void:
	weapon = weapon + 1

func _on_timer_timeout() -> void:
	$Range/Polygon2D.visible = false

func _on_auto_heal_timeout() -> void:
	changeHealth(autoHealPower)

func formatTime(number: int):
	var result = str(number)
	if len(result) == 1:
		return "0" + result
	return result

func _on_global_timer_timeout() -> void:
	seconds = seconds + 1
	minutes = seconds / 60
	$Chronometer.text = formatTime(minutes) + ":" + formatTime(seconds % 60)
	$"..".increaseDifficulty(seconds)
	if minutes == 30:
		$Success.show()
		get_tree().paused = true

func _on_continue_pressed() -> void:
	$PauseMenu.hide()
	get_tree().paused = false
