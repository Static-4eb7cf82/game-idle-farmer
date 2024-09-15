extends Sprite2D

class_name CarryableItem

@export var item: CollectableItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    texture = item.texture
