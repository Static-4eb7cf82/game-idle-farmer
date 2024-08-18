extends CharacterBody2D


const SPEED = 50.0 # 25 is more appropriate for automated movement
var character_direction := direction.DOWN

enum direction {
    UP,
    DOWN,
    LEFT,
    RIGHT
}

func _physics_process(_delta: float) -> void:

    # Get the input direction and handle the movement/deceleration.
    var y_direction := Input.get_axis("up", "down")
    if y_direction:
        velocity.y = y_direction * SPEED
        velocity.x = 0
        if velocity.y > 0:
            character_direction = direction.DOWN
        else:
            character_direction = direction.UP
    else:
        velocity.y = 0

        var x_direction := Input.get_axis("left", "right")
        if x_direction:
            velocity.x = x_direction * SPEED
            if velocity.x > 0:
                character_direction = direction.RIGHT
            else:
                character_direction = direction.LEFT
        else:
            velocity.x = 0

    handle_animation()
    move_and_slide()

func handle_animation() -> void:
    if velocity.x != 0 or velocity.y != 0:
        if character_direction == direction.UP:
            $AnimatedSprite2D.play("back_walk")
        elif character_direction == direction.DOWN:
            $AnimatedSprite2D.play("front_walk")
        elif character_direction == direction.LEFT:
            $AnimatedSprite2D.play("left_walk")
        else:
            $AnimatedSprite2D.play("right_walk")
    else:
        if character_direction == direction.UP:
            $AnimatedSprite2D.play("back_idle")
        elif character_direction == direction.DOWN:
            $AnimatedSprite2D.play("front_idle")
        elif character_direction == direction.LEFT:
            $AnimatedSprite2D.play("left_idle")
        else:
            $AnimatedSprite2D.play("right_idle")
