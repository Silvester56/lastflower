extends Node2D

func setProperties(offset, rank) -> void:
	$Label.text = str(rank)
	position.x = offset
	$Sprite2D.region_rect = Rect2(offset, 0, 32, 32)
