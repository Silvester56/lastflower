extends Control

signal upgrade_purchased

var upgradeIdentifier

func setProperties(nameText, labelText, rank, id) -> void:
	$Name.text = nameText
	$Description.text = labelText
	$Rank.text = "Rank : " + str(rank)
	upgradeIdentifier = id

func _on_button_pressed() -> void:
	emit_signal("upgrade_purchased", upgradeIdentifier)
