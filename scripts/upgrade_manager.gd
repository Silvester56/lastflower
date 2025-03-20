extends VBoxContainer

@export var Upgrade: PackedScene

var allUpgrades = {
	"AUTO_HEAL_SPEED": 1,
	"AUTO_HEAL_POWER": 1,
	"MELEE_COOLDOWN": 1,
	"SHROOMS": 1,
	"THORNS": 1,
	"SHOOTING_WEAPON": 1
}

func onLevelUp(level) -> void:
	var availableUpgrades = []
	var possibleUpgrade
	show()
	get_tree().paused = true
	if len(allUpgrades) <= 3:
		availableUpgrades = allUpgrades.keys()
	else :
		while len(availableUpgrades) < 3:
			possibleUpgrade = allUpgrades.keys().pick_random()
			if not availableUpgrades.has(possibleUpgrade):
				availableUpgrades.push_front(possibleUpgrade)
	for upgradeId in availableUpgrades:
		createUpgrade(upgradeId, allUpgrades[upgradeId])

func createUpgrade(upgradeId, rank):
	var result = Upgrade.instantiate()
	if upgradeId == "AUTO_HEAL_SPEED":
		result.setProperties("Sap speed", "Makes auto heal faster", rank, upgradeId)
	if upgradeId == "AUTO_HEAL_POWER":
		result.setProperties("Sap power", "More health per auto heal", rank, upgradeId, 64)
	if upgradeId == "MELEE_COOLDOWN":
		result.setProperties("Whip", "Decreases melee attack cooldown", rank, upgradeId, 32)
	if upgradeId == "SHROOMS":
		result.setProperties("Shrooms", "Mushrooms grow around the flower to protect it", rank, upgradeId, 96)
	if upgradeId == "SHOOTING_POWER":
		result.setProperties("Spikes", "Each projectiles deal more damage", rank, upgradeId)
	if upgradeId == "SHOOTING_COOLDOWN":
		result.setProperties("Reload", "Decreases weapon cooldown", rank, upgradeId)
	if upgradeId == "THORNS":
		if rank == 1:
			result.setProperties("Thorns", "Enemies on the flower have a chance of getting hit", rank, upgradeId, 128)
		else:
			result.setProperties("Thorns", "Enemies on the flower have more chances of getting hit", rank, upgradeId, 128)
	if upgradeId == "SHOOTING_WEAPON":
		if rank == 1:
			result.setProperties("Slingshot", "Long distance weapon", rank, upgradeId)
		elif rank == 2:
			result.setProperties("Slingshotgun", "Fires 3 projectiles", rank, upgradeId)
		elif rank == 3:
			result.setProperties("Slingshotgun 2", "Fires 5 projectiles", rank, upgradeId)
		elif rank == 4:
			result.setProperties("Turret", "Fires in 8 directions", rank, upgradeId)
		elif rank == 5:
			result.setProperties("Turret 2", "Fires in 16 directions", rank, upgradeId)
	result.connect("upgrade_purchased", _on_upgrade_purchased)
	add_child(result)
	
func _on_upgrade_purchased(upgradeIdentifier) -> void:
	hide()
	for c in get_children():
		if "upgradeIdentifier" in c:
			c.queue_free()
	get_tree().paused = false
	$"..".displayUpgrade(upgradeIdentifier)
	allUpgrades[upgradeIdentifier] = allUpgrades[upgradeIdentifier] + 1
	if allUpgrades[upgradeIdentifier] == 6:
		allUpgrades.erase(upgradeIdentifier)
	if upgradeIdentifier == "AUTO_HEAL_SPEED":
		$"../..".increaseAutoHealSpeed()
	if upgradeIdentifier == "AUTO_HEAL_POWER":
		$"../..".increaseAutoHealPower()
	if upgradeIdentifier == "MELEE_COOLDOWN":
		$"..".decreaseMeleeCooldown()
	if upgradeIdentifier == "SHROOMS":
		pass
	if upgradeIdentifier == "THORNS":
		$"../../Flower".increaseThorns()
	if upgradeIdentifier == "SHOOTING_WEAPON":
		allUpgrades["SHOOTING_POWER"] = 1
		allUpgrades["SHOOTING_COOLDOWN"] = 1
		$"..".nextWeapon()
	if upgradeIdentifier == "SHOOTING_POWER":
		$"..".increaseShootingPower()
	if upgradeIdentifier == "SHOOTING_COOLDOWN":
		$"..".decreaseShootingCooldown()
