extends CharacterBody2D

var region: Region
const SPEED = 50.0 # 25 is more appropriate for automated movement
var character_direction := direction.DOWN
var performing_action_animation := false

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
            if event.keycode == KEY_2:
                perform_harvest_crop()


func perform_water() -> void:
    # water at the grid cell in front of the cat
    # i.e. water the grid cell at cat position + 1 grid cell in cat's direction
    # print("Watering the crop")
    
    # print("get_grid_coords_at_mouse: ", region.get_grid_coords_at_mouse())
    # print("get_grid_coords_from_pos(position): ", region.get_grid_coords_from_pos(position))
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

    var water_cell_coords := cat_grid_coords + direction_offset
    print("water at coords: ", water_cell_coords)
    region.place_water_at_coords(water_cell_coords)
    performing_action_animation = true
    match character_direction:
        direction.UP:
            $AnimatedSprite2D.play("back_water")
            $WaterFromCanAnimation.flip_h = true
            $WaterFromCanAnimation.position = Vector2(2, -4)
            $WaterFromCanAnimation.play("front_water")
        direction.DOWN:
            $AnimatedSprite2D.play("front_water")
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.position = Vector2(0, 0)
            $WaterFromCanAnimation.play("front_water")
        direction.LEFT:
            $AnimatedSprite2D.play("left_water")
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.play("left_water")
            $WaterFromCanAnimation.position = Vector2(-14, 0)
        direction.RIGHT:
            $AnimatedSprite2D.play("right_water")
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.play("right_water")
            $WaterFromCanAnimation.position = Vector2(14, 0)

func perform_harvest_crop() -> void:
    # harvest at the grid cell in front of the cat
    # i.e. harvest the grid cell at cat position + 1 grid cell in cat's direction
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

    var perform_action_at_cell_coords := cat_grid_coords + direction_offset
    print("harvest at coords: ", perform_action_at_cell_coords)
    harvest_crop_at_coords(perform_action_at_cell_coords)


var harvested_wheat_packed_scene := preload("res://scenes/harvestables/harvested_wheat.tscn")
func harvest_crop_at_coords(coords: Vector2i) -> void:
    # get a reference to the crop at the coords
    # iterate through region crops, and find the one at given coords
    # based on the crop type, instantiate new "harvested" crop sprite and place above cat
    # queue_free() the crop
    # set the grid cell at coords to be plottable again
    # then go_to_nearest_storage()
    # Todo: only harvest the crop if it has completed growing
    var crop := region.get_crop_at_coords(coords)
    if not crop:
        print("No crop to harvest at coords: ", coords)
        return

    var harvested_item_packed_scene: PackedScene
    match crop.crop_type:
        Global.CROP_TYPE.WHEAT:
            print("Harvested wheat at coords: ", coords)
            harvested_item_packed_scene = harvested_wheat_packed_scene

        Global.CROP_TYPE.BEET:
            print("Harvested beet at coords: ", coords)
        Global.CROP_TYPE.LETTUCE:
            print("Harvested lettuce at coords: ", coords)
        Global.CROP_TYPE.CARROT:
            print("Harvested carrot at coords: ", coords)

    if harvested_item_packed_scene:
        var instance := harvested_item_packed_scene.instantiate() as HarvestableItem
        instance.position = Vector2(0, -20)
        add_child(instance)

        crop.queue_free()
        region.get_grid_cell_from_coords(coords).is_plottable = true


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
    if performing_action_animation:
        return
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

func _on_water_from_can_animation_animation_finished() -> void:
    performing_action_animation = false
    handle_animation()
