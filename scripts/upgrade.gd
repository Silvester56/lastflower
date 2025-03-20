extends Control

signal upgrade_purchased

var upgradeIdentifier

func setProperties(nameText, labelText, rank, id, spriteOffset = 0) -> void:
	$Name.text = nameText
	$Description.text = labelText
	$Rank.text = "Rank : " + str(rank)
	$Sprite2D.region_rect = Rect2(spriteOffset, 0, 32, 32)
	upgradeIdentifier = id

func _on_button_pressed() -> void:
	emit_signal("upgrade_purchased", upgradeIdentifier)
