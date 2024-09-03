extends CharacterBody2D

class_name CatWorker

var region: Region
const SPEED = 50.0 # 25 is more appropriate for automated movement
var performing_action_animation := false
var carrying_harvestable : HarvestableItem

# Target based movement
var move_to_target := false
var target_position: Vector2 = Vector2.ZERO
signal reached_target_position()

# Jobs
var performing_job := false


var character_direction := DIRECTION_DOWN
const DIRECTION_DOWN = "down"
const DIRECTION_UP = "up"
const DIRECTION_LEFT = "left"
const DIRECTION_RIGHT = "right"


func _process(_delta: float) -> void:
    poll_and_receive_jobs()


func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.pressed:
            if event.keycode == KEY_1:
                perform_water()
            if event.keycode == KEY_2:
                perform_harvest_crop()
            if event.keycode == KEY_3:
                perform_place_item_in_storage()


func _physics_process(_delta: float) -> void:
    if move_to_target:
        handle_target_movement()
    else:
        handle_player_provided_movement()
    move_and_slide()
    handle_animation()


func handle_player_provided_movement() -> void:
    # Get the input DIRECTION and handle the movement/deceleration.
    var y_direction := Input.get_axis("up", "down")
    if y_direction:
        velocity.y = y_direction * SPEED
        velocity.x = 0
        if velocity.y > 0:
            character_direction = DIRECTION_DOWN
        else:
            character_direction = DIRECTION_UP
    else:
        velocity.y = 0

        var x_direction := Input.get_axis("left", "right")
        if x_direction:
            velocity.x = x_direction * SPEED
            if velocity.x > 0:
                character_direction = DIRECTION_RIGHT
            else:
                character_direction = DIRECTION_LEFT
        else:
            velocity.x = 0


func move_to_desired_target_position(target_pos: Vector2) -> void:
    # print("Moving to desired target position: ", target_pos)
    var actual_target_pos := get_closest_adjacent_target_position(target_pos)
    target_position = actual_target_pos
    move_to_target = true
    # print("moving to actual target position: ", target_position)


func get_closest_adjacent_target_position(target_pos: Vector2) -> Vector2:
    var target_grid_coords := region.get_grid_coords_from_pos(target_pos)
    var adjacent_grid_coords := [
        target_grid_coords + Vector2i(0, 1),
        target_grid_coords + Vector2i(0, -1),
        target_grid_coords + Vector2i(1, 0),
        target_grid_coords + Vector2i(-1, 0)
    ]
    var adjacent_grid_positions := adjacent_grid_coords.map(region.get_grid_pos_from_coords)
    
    var closest_pos = adjacent_grid_positions[0]
    var closest_distance := position.distance_to(closest_pos)
    for pos: Vector2 in adjacent_grid_positions:
        var cur_distance := position.distance_to(pos)
        if cur_distance < closest_distance:
            closest_pos = pos
            closest_distance = cur_distance
    
    return closest_pos


func handle_target_movement() -> void:
    if move_to_target:
        var direction := (target_position - position).normalized()
        velocity = direction * SPEED
        if position.distance_to(target_position) < 1: # physics buffer position offset
            move_to_target = false
            velocity = Vector2.ZERO
            reached_target_position.emit()
            print("Reached target position")


func poll_and_receive_jobs() -> void:
    if performing_job:
        return
    
    if !region.job_queue.is_empty():
        print("Receiving a job")
        # var job_queue : JobQueue = region.job_queue
        var job : Job = region.job_queue.pop() # Perform any job category for now
        
        performing_job = true
        if job is TillJob:
            await execute_till_job(job)
        # Global.JOB_TYPE.WATER:
        #     perform_water()
        # Global.JOB_TYPE.HARVEST:
        #     perform_harvest_crop()
        # Global.JOB_TYPE.BUILD_WORKBENCH:
        #     print("Build workbench job")
        performing_job = false
        print("Finished job")


func execute_till_job(till_job: TillJob) -> void:

    # move to target position
    # print("moving to position")
    move_to_desired_target_position(till_job.pos)
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    turn_towards_target_position(till_job.pos)
    
    # perform animation for job duration
    # print("performing till soil animation")
    performing_action_animation = true
    $AnimatedSprite2D.play("till_" + character_direction)
    var job_duration := 5
    await get_tree().create_timer(job_duration).timeout
    performing_action_animation = false
    $AnimatedSprite2D.play("idle_" + character_direction)

    # spawn tilled soil
    # print("placing tilled soil")
    region.place_tilled_soil_at_coords(region.get_grid_coords_from_pos(till_job.pos))


func turn_towards_target_position(target_pos: Vector2) -> void:
    var position_diff := (target_pos - position).abs()
    if position_diff.x > position_diff.y:
        if target_pos.x > position.x:
            character_direction = DIRECTION_RIGHT
        else:
            character_direction = DIRECTION_LEFT
    else:
        if target_pos.y > position.y:
            character_direction = DIRECTION_DOWN
        else:
            character_direction = DIRECTION_UP

func handle_animation() -> void:
    if performing_action_animation:
        return

    if move_to_target:
        var distance := (target_position - position).abs()
        if distance.x > distance.y:
            if velocity.x > 0:
                character_direction = DIRECTION_RIGHT
            else:
                character_direction = DIRECTION_LEFT
        else:
            if velocity.y > 0:
                character_direction = DIRECTION_DOWN
            else:
                character_direction = DIRECTION_UP
        
        $AnimatedSprite2D.play("walk_" + character_direction)
        return

    if velocity.x != 0 or velocity.y != 0:
        $AnimatedSprite2D.play("walk_" + character_direction)
    else:
        $AnimatedSprite2D.play("idle_" + character_direction)


func perform_water() -> void:
    var perform_action_at_cell_coords := get_coords_in_front_of_cat()
    print("water at coords: ", perform_action_at_cell_coords)
    region.place_water_at_coords(perform_action_at_cell_coords)
    performing_action_animation = true
    match character_direction:
        DIRECTION_UP:
            $WaterFromCanAnimation.flip_h = true
            $WaterFromCanAnimation.position = Vector2(2, -4)
            $WaterFromCanAnimation.play("water_vertical")
        DIRECTION_DOWN:
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.position = Vector2(0, 0)
            $WaterFromCanAnimation.play("water_vertical")
        DIRECTION_LEFT:
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.play("water_" + character_direction)
            $WaterFromCanAnimation.position = Vector2(-14, 0)
        DIRECTION_RIGHT:
            $WaterFromCanAnimation.flip_h = false
            $WaterFromCanAnimation.play("water_" + character_direction)
            $WaterFromCanAnimation.position = Vector2(14, 0)
    
    $AnimatedSprite2D.play("water_" + character_direction)


func perform_harvest_crop() -> void:
    var perform_action_at_cell_coords := get_coords_in_front_of_cat()
    print("harvest at coords: ", perform_action_at_cell_coords)
    harvest_crop_at_coords(perform_action_at_cell_coords)


var harvested_wheat_packed_scene := preload("res://scenes/harvestables/harvested_wheat.tscn")
var harvested_beet_packed_scene := preload("res://scenes/harvestables/harvested_beet.tscn")
var harvested_lettuce_packed_scene := preload("res://scenes/harvestables/harvested_lettuce.tscn")
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
            harvested_item_packed_scene = harvested_beet_packed_scene
        Global.CROP_TYPE.LETTUCE:
            harvested_item_packed_scene = harvested_lettuce_packed_scene

    if harvested_item_packed_scene:
        print("Harvested %s at coords: %s" % [crop.crop_type, coords])
        var instance := harvested_item_packed_scene.instantiate() as HarvestableItem
        instance.position = Vector2(0, -24)
        add_child(instance)
        carrying_harvestable = instance

        crop.queue_free()
        region.get_grid_cell_from_coords(coords).is_plottable = true


func perform_place_item_in_storage() -> void:
    var storage := region.get_storage_at_coords(get_coords_in_front_of_cat()) as StorageContainer
    # open storage
    # call carrying_harvestable.recieve_reward()
    # queue_free() carrying_harvestable
    # set carrying_harvestable to null
    if storage:
        storage.storage_container_opened.connect(on_storage_container_opened)
        storage.open()

func on_storage_container_opened() -> void:
    print("Storage container opened")
    carrying_harvestable.recieve_reward()
    carrying_harvestable.queue_free()
    carrying_harvestable = null
    var storage := region.get_storage_at_coords(get_coords_in_front_of_cat()) as StorageContainer
    if storage:
        storage.close()


func _on_water_from_can_animation_animation_finished() -> void:
    performing_action_animation = false
    handle_animation()


func get_coords_in_front_of_cat() -> Vector2i:
    # Get the coords in front of the cat
    # i.e. grid cell at cat position + 1 grid cell in cat's DIRECTION
    var cat_grid_coords := region.get_grid_coords_from_pos(position)
    var direction_offset : Vector2i
    match character_direction:
        DIRECTION_UP:
            direction_offset = Vector2i(0, -1)
        DIRECTION_DOWN:
            direction_offset = Vector2i(0, 1)
        DIRECTION_LEFT:
            direction_offset = Vector2i(-1, 0)
        DIRECTION_RIGHT:
            direction_offset = Vector2i(1, 0)

    var coords_in_front_of_cat := cat_grid_coords + direction_offset
    return coords_in_front_of_cat
