extends AnimatedSprite2D


func _ready() -> void:
    hide()


func _on_animation_finished() -> void:
    hide()


# Used to determine when the animation is playing and should be shown
func _on_frame_changed() -> void:
    if visible:
        return
    show()
