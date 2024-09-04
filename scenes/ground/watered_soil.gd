extends Node2D

class_name WateredSoil


var region: Region
var coords: Vector2i

signal water_has_expired


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    ($Timer as Timer).start()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_timer_timeout() -> void:
    region.expire_water_at_coords(coords)
    water_has_expired.emit()
    queue_free()
