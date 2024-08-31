extends CharacterBody2D

var region: Region
const SPEED = 50.0 # 25 is more appropriate for automated movement
var character_direction := direction.DOWN
var performing_action_animation := false
var carrying_harvestable : HarvestableItem

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
            if event.keycode == KEY_3:
                perform_place_item_in_storage()


func perform_water() -> void:
    var perform_action_at_cell_coords := get_coords_in_front_of_cat()
    print("water at coords: ", perform_action_at_cell_coords)
    region.place_water_at_coords(perform_action_at_cell_coords)
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
    var perform_action_at_cell_coords := get_coords_in_front_of_cat()
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
    var crop := region.get_crop_at_coords(coords)
    if not crop:
        print("No crop to harvest at coords: ", coords)
        return

    if not crop.completedGrowing:
        print("Crop not ready to harvest at coords: ", coords)
        return

    var harvested_item_packed_scene: PackedScene
    match crop.crop_type:
        Global.CROP_TYPE.WHEAT:
            harvested_item_packed_scene = harvested_wheat_packed_scene
        Global.CROP_TYPE.BEET:
            harvested_item_packed_scene = harvested_wheat_packed_scene
        Global.CROP_TYPE.LETTUCE:
            harvested_item_packed_scene = harvested_wheat_packed_scene
        Global.CROP_TYPE.CARROT:
            harvested_item_packed_scene = harvested_wheat_packed_scene

    if harvested_item_packed_scene:
        print("Harvested %s at coords: %s" % [crop.crop_type, coords])
        var instance := harvested_item_packed_scene.instantiate() as HarvestableItem
        instance.position = Vector2(0, -20)
        add_child(instance)
        carrying_harvestable = instance

        crop.queue_free()
        region.get_grid_cell_from_coords(coords).is_plottable = true


func perform_place_item_in_storage() -> void:
    var storage := region.get_storage_at_coords(get_coords_in_front_of_cat()) as Node2D
    # open storage
    # call carrying_harvestable.recieve_reward()
    # queue_free() carrying_harvestable
    # set carrying_harvestable to null
    if storage:
        storage.open()
        carrying_harvestable.recieve_reward()
        carrying_harvestable.queue_free()
        carrying_harvestable = null
    pass


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


func get_coords_in_front_of_cat() -> Vector2i:
    # Get the coords in front of the cat
    # i.e. grid cell at cat position + 1 grid cell in cat's direction
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

    var coords_in_front_of_cat := cat_grid_coords + direction_offset
    return coords_in_front_of_cat