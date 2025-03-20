extends CharacterBody2D

@export var UpgradePurchased: PackedScene
@export var Bullet: PackedScene

var speed = 100.0
var meleePower = 1
var xp: int = 0
var xpForNextLevel: int = 5
var level = 1
var health: int = 100
var autoHealPower: int = 1
var meleeCooldown = 15
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
		var bullet = Bullet.instantiate()
		var target = get_global_mouse_position()
		bullet.direction = global_position.direction_to(target).normalized()
		add_child(bullet)
	if Input.is_action_just_pressed("melee") and $MeleeCooldown.is_stopped():
		$Range/Polygon2D.visible = true
		$Range/Timer.start()
		$MeleeCooldown.start()
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
		$GameOver.show()
		get_tree().paused = true

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
		$UpgradeManager.onLevelUp(level)
	$Experience.value = xp

func decreaseMeleeCooldown() -> void:
	meleeCooldown = meleeCooldown - 1
	$MeleeCooldown.wait_time = meleeCooldown / 10

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
	if minutes == 30:
		$Success.show()
		get_tree().paused = true
