extends CharacterBody2D

var region: Region
const SPEED = 50.0 # 25 is more appropriate for automated movement
var character_direction := direction.DOWN

enum direction {
    UP,
    DOWN,
    LEFT,
    RIGHT
}


func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.pressed:
            if event.keycode == KEY_1:
                perform_water()

func perform_water() -> void:
    # water at the grid cell in front of the cat
    # i.e. water the grid cell at cat position + 1 grid cell in cat's direction
    print("Watering the crop")
    
    print("get_grid_coords_at_mouse: ", region.get_grid_coords_at_mouse())
    print("get_grid_coords_from_pos(position): ", region.get_grid_coords_from_pos(position))
    var cat_grid_coords := region.get_grid_coords_from_pos(position)
    var direction_offset : Vector2i
    match character_direction:
        direction.UP:
            direction_offset = Vector2i(0, -1)
        direction.DOWN:
            direction_offset = Vector2i(0, 1)
        direction.LEFT:
            direction_offset = Vector2i(-1, 0)
        direction.RIGHT:
            direction_offset = Vector2i(1, 0)

    var water_cell := region.get_grid_cell_from_coords(cat_grid_coords + direction_offset)
    var water_cell_coords := cat_grid_coords + direction_offset
    print("water coords: ", water_cell_coords)
    print("Water cell: ", water_cell)
    region.ground_tile_map.set_cell(2, water_cell_coords, 7, Vector2i(0, 0))


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
