extends VBoxContainer

@export var Upgrade: PackedScene

enum upgradeId {
	AUTO_HEAL_SPEED,
	AUTO_HEAL_POWER,
	MELEE_COOLDOWN,
	SHOOT,
	SHOOT_COOLDOWN,
}

func onLevelUp(level) -> void:
	show()
	get_tree().paused = true
	if level == 2:
		createUpgrade("Sap speed", "Makes auto heal faster", 1, upgradeId.AUTO_HEAL_SPEED)
		createUpgrade("Sap power", "More health per auto heal", 1, upgradeId.AUTO_HEAL_POWER)
		createUpgrade("Spores", "Decreases melee attack cooldown", 1, upgradeId.MELEE_COOLDOWN)

func createUpgrade(buttonText, labelText, rank, identifier):
	var result = Upgrade.instantiate()
	result.setProperties(buttonText, labelText, rank, identifier)
	result.connect("upgrade_purchased", _on_upgrade_purchased)
	add_child(result)
	
func _on_upgrade_purchased(upgradeIdentifier) -> void:
	hide()
	get_tree().paused = false
	if upgradeIdentifier == upgradeId.AUTO_HEAL_SPEED:
		$"../..".increaseAutoHealSpeed()
	if upgradeIdentifier == upgradeId.AUTO_HEAL_POWER:
		$"../..".increaseAutoHealPower()
	if upgradeIdentifier == upgradeId.MELEE_COOLDOWN:
		$"..".decreaseMeleeCooldown()
	if upgradeIdentifier == upgradeId.SHOOT:
		$"..".turnOnShooting()
