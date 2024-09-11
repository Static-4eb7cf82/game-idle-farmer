extends FollowMouse

class_name TillSoilAction

var price: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func dispose() -> void:
    Player.selected_action = Player.SELECTED_ACTION.NONE
    queue_free()