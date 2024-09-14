extends CharacterBody2D

class_name CatWorker

var region: Region
var speed: float = Global.settings.cat_worker_speed
var performing_action_animation := false
var water_count: int = Global.settings.cat_worker_water_count
var carryable_item : CarryableItem

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
                perform_water_in_front_of_cat()


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
        velocity.y = y_direction * speed
        velocity.x = 0
        if velocity.y > 0:
            character_direction = DIRECTION_DOWN
        else:
            character_direction = DIRECTION_UP
    else:
        velocity.y = 0

        var x_direction := Input.get_axis("left", "right")
        if x_direction:
            velocity.x = x_direction * speed
            if velocity.x > 0:
                character_direction = DIRECTION_RIGHT
            else:
                character_direction = DIRECTION_LEFT
        else:
            velocity.x = 0


func move_to_position(target_pos: Vector2) -> void:
    target_position = target_pos
    move_to_target = true


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
    for pos: Vector2 in adjacent_grid_positions:
        var cur_distance := position.distance_to(pos)
        if cur_distance < position.distance_to(closest_pos):
            closest_pos = pos
    
    return closest_pos


func handle_target_movement() -> void:
    if move_to_target:
        var direction := (target_position - position).normalized()
        velocity = direction * speed
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
        elif job is WaterJob:
            await execute_water_job(job)
        elif job is HarvestJob:
            await execute_harvest_job(job)
        elif job is ChopTreeJob:
            await execute_chop_tree_job(job)
        # Global.JOB_TYPE.WATER:
        #     perform_water_in_front_of_cat()
        # Global.JOB_TYPE.HARVEST:
        #     perform_harvest_crop()
        # Global.JOB_TYPE.BUILD_WORKBENCH:
        #     print("Build workbench job")
        performing_job = false
        print("Finished job")
    else:
        # Do nothing
        $AnimatedSprite2D.play("idle_" + character_direction)


func execute_till_job(till_job: TillJob) -> void:

    # move to target position
    # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(till_job.pos))
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(till_job.pos)
    
    # perform animation for job duration
    # print("performing till soil animation")
    performing_action_animation = true
    $AnimatedSprite2D.play("till_" + character_direction)
    var job_duration := 5
    await get_tree().create_timer(job_duration).timeout
    performing_action_animation = false

    # spawn tilled soil
    # print("placing tilled soil")
    region.place_tilled_soil_at_coords(region.get_grid_coords_from_pos(till_job.pos))


func execute_water_job(water_job: WaterJob) -> void:

    # move to target position
    # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(water_job.pos))
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(water_job.pos)
    
    # perform animation for job duration
    # print("performing water animation")
    var watered_soil := await perform_water_in_front_of_cat()
    water_job._subject.water = watered_soil
    water_count -= 1

    # Check if need to refill water
    if water_count <= 0:
        await execute_refill_water()


func execute_refill_water() -> void:
    # ask the region for the closest water well
    var closest_water_well := region.get_closest_water_well_to_pos(position)

    # move to target position
    # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(closest_water_well.position))
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(closest_water_well.position)

    # perform refill water
    await perform_refill_water()


func perform_refill_water() -> void:
    # perform animation for job duration
    # print("performing refill water animation")
    performing_action_animation = true
    # play animation water_count times
    for i in range(Global.settings.cat_worker_water_count):
        $AnimatedSprite2D.play("water_" + character_direction)
        await $AnimatedSprite2D.animation_finished
    performing_action_animation = false

    # refill water
    water_count = Global.settings.cat_worker_water_count


func execute_harvest_job(harvest_job: HarvestJob) -> void:

    # move to target position. Move to the literal crop position, not adjacent to it, so it looks like youre actually picking it up
    # print("moving to position")
    move_to_position(harvest_job.pos)
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(harvest_job.pos)

    # perform harvest
    # this will call harvest on the crop
    # the crop will know what it needs to do to be harvested, i.e. turn off growing processing etc + hide animation sprite and show the harvested sprite
    # cat worker will await this
    harvest_job._subject.harvest(self)

    # ask the region for the closest storage container
    var closest_storage := region.get_closest_storage_to_pos(position)

    # move to target position
    # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(closest_storage.position))
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(closest_storage.position)

    # perform place in container and recieve reward
    await place_item_in_storage(harvest_job._subject, closest_storage)


func execute_chop_tree_job(chop_tree_job: ChopTreeJob) -> void:

    # move to target position
    # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(chop_tree_job.pos))
    await reached_target_position

    # turn towards target position
    # print("turning towards target position")
    set_character_direction_towards_target_position(chop_tree_job.pos)
    
    # perform animation for job duration
    print("start harvest tree")
    chop_tree_job._subject.start_harvest()
    
    # start hitting the tree
    while not chop_tree_job._subject.harvest_finished:
        performing_action_animation = true
        $AnimatedSprite2D.play("chop_pt1_" + character_direction)
        await $AnimatedSprite2D.animation_finished
        chop_tree_job._subject.on_hit()
        $AnimatedSprite2D.play("chop_pt2_" + character_direction)
        await $AnimatedSprite2D.animation_finished
        performing_action_animation = false
    print("Stopped hitting the tree")
    $AnimatedSprite2D.play("idle_" + character_direction)

    var dropped_item : DroppedItem = await chop_tree_job._subject.item_dropped
    dropped_item.give_to(self)
    await dropped_item.collected

    # print("Collected item")
    # ask the region for the closest storage container
    var closest_storage := region.get_closest_storage_to_pos(position)

    # # move to target position
    # # print("moving to position")
    move_to_position(get_closest_adjacent_target_position(closest_storage.position))
    await reached_target_position

    # # turn towards target position
    # # print("turning towards target position")
    set_character_direction_towards_target_position(closest_storage.position)

    # perform place in container and recieve reward
    await place_carryable_item_in_storage(closest_storage)


func set_character_direction_towards_target_position(target_pos: Vector2) -> void:
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


func perform_water_in_front_of_cat() -> WateredSoil:
    var perform_action_at_cell_coords := get_coords_in_front_of_cat()
    print("water at coords: ", perform_action_at_cell_coords)
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

    await $WaterFromCanAnimation.animation_finished
    performing_action_animation = false
    var watered_soil = region.place_water_at_coords(perform_action_at_cell_coords)
    return watered_soil


func place_item_in_storage(item: Crop, storage_container: StorageContainer) -> void:
    # open storage
    # call item.recieve_reward()
    # queue_free() item
    await storage_container.open()

    # print("Storage container opened")
    item.recieve_reward()
    item.queue_free()

    storage_container.close()


func place_carryable_item_in_storage(storage_container: StorageContainer) -> void:
    # open storage
    # call item.recieve_reward()
    # queue_free() item
    await storage_container.open()

    # print("Storage container opened")
    carryable_item.item.recieve_reward()
    carryable_item.queue_free()
    carryable_item = null

    storage_container.close()


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


var carryable_item_scene := preload("res://scenes/objects/items/carryable_item.tscn")
func collect_item(item: CollectableItem) -> void:
    print("Cat Worker collected item")
    carryable_item = carryable_item_scene.instantiate() as CarryableItem
    carryable_item.item = item
    add_child(carryable_item)
    # put item above cat: cat worker height + margin between + item radius
    carryable_item.position = Vector2(0, -16) + Vector2(0, -1 * carryable_item.item.radius)
