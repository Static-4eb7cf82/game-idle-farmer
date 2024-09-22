extends Node2D

class_name WateredSoil


var region: Region
var coords: Vector2i

signal water_has_expired


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    ($Timer as Timer).wait_time = Global.settings.watered_soil_duration
    ($Timer as Timer).start()
    pass # Replace with function body.


func _on_timer_timeout() -> void:
    water_has_expired.emit()
    dispose()


func dispose() -> void:
    region.expire_water_at_coords(coords)
    queue_free()