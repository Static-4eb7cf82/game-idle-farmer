extends Node2D

class_name Region


@export
var region_name: String
@export
var ground_tile_map: TileMap
@export
var tilled_soil_tile_map: TileMap
var grid: Array
var crops_group_name: String
var cats_group_name: String
var storage_group_name: String
var job_queue : JobQueue = JobQueue.new()

class GridCellState:
    
    func _init(plottable: bool, water: bool) -> void:
        self.is_plottable = plottable
        self.has_water = water

    # is_plottable doubles as being a tile possible to hold a crop as well as being occupied by a crop
    # corner tilled tiles will always be false, but inner tiles will be true by default
    var is_plottable: bool
    var has_water: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var dimensions := ground_tile_map.get_used_rect().size
    for y in dimensions.y:
        grid.append([])
        for x in dimensions.x:
            grid[y].append(null)
    
    debug_seed_grid()

    crops_group_name = "%s_crops" % region_name
    cats_group_name = "%s_cat_workers" % region_name
    storage_group_name = "%s_storage" % region_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

    # This exists in _process to allow holding down the mouse to plant seeds
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Player.selected_seed_packet:
        var clicked_tilemap_coords := ground_tile_map.local_to_map(self.get_local_mouse_position())
        var clicked_grid_cell := get_grid_cell_from_coords(clicked_tilemap_coords)
        if clicked_grid_cell and clicked_grid_cell.is_plottable:
            # instantiate the crop type that the player has selected at these coords
            # Plant it and set input as handled
            if Player.coins < Player.selected_seed_packet.price:
                print("Not enough coins to plant this crop")
                return
            plant_crop(Player.selected_seed_packet, ground_tile_map.map_to_local(clicked_tilemap_coords))
            clicked_grid_cell.is_plottable = false
    if Input.is_action_just_pressed("accept") and Player.till_soil_selected:
        print("Adding TillJob to job queue")
        job_queue.push(TillJob.new(get_global_mouse_position()))
        get_viewport().set_input_as_handled();

# func _unhandled_input(event: InputEvent) -> void:
#     if Input.is_action_just_released("accept") and Player.till_soil_selected:
#         print("Adding TillJob to job queue")
#         job_queue.push(TillJob.new(get_global_mouse_position()))
#         get_viewport().set_input_as_handled();


func set_grid_cell(pos: Vector2i, cell_state: GridCellState) -> void:
    grid[pos.y][pos.x] = cell_state


func get_grid_coords_at_mouse() -> Vector2i:
    var coords := get_grid_coords_from_pos(get_global_mouse_position())
    print("Grid coords at mouse: ", coords)
    return coords


func get_grid_cell_at_mouse() -> GridCellState:
    return get_grid_cell_from_coords(get_grid_coords_at_mouse())


func get_grid_coords_from_pos(pos: Vector2) -> Vector2i:
    var coords := ground_tile_map.local_to_map(pos)
    return coords


func get_grid_pos_from_coords(coords: Vector2i) -> Vector2:
    return ground_tile_map.map_to_local(coords)


func get_grid_cell_from_coords(pos: Vector2i) -> GridCellState:
    if pos.y < grid.size() and pos.x < grid[0].size():
        return grid[pos.y][pos.x]
    else:
        return null


var wheat_crop_scene := preload("res://scenes/growables/wheat.tscn")
var beet_crop_scene := preload("res://scenes/growables/beet.tscn")
var lettuce_crop_scene := preload("res://scenes/growables/lettuce.tscn")
func plant_crop(selected_seed_packet: SelectedSeedPacket, pos: Vector2) -> void:
    var crop_packed_scene: PackedScene
    match selected_seed_packet.crop_type:
        Global.CROP_TYPE.WHEAT:
            crop_packed_scene = wheat_crop_scene
        Global.CROP_TYPE.BEET:
            crop_packed_scene = beet_crop_scene
        Global.CROP_TYPE.LETTUCE:
            crop_packed_scene = lettuce_crop_scene

    if crop_packed_scene:
        var instance := crop_packed_scene.instantiate() as Crop
        instance.position = pos
        instance.region = self
        instance.crop_type = selected_seed_packet.crop_type
        add_child(instance)
        instance.add_to_group(crops_group_name)

        Player.coins -= selected_seed_packet.price
        print("Player coins after planting: ", Player.coins)


var watered_soil_packed_scene := preload("res://scenes/ground/watered_soil.tscn")
var watered_soil_layer := 1
func place_water_at_coords(coords: Vector2i) -> void:
    var watered_soil_instance := watered_soil_packed_scene.instantiate() as Node2D
    watered_soil_instance.coords = coords
    watered_soil_instance.region = self
    add_child(watered_soil_instance)

    tilled_soil_tile_map.set_cell(watered_soil_layer, coords, 2, Vector2i(0, 0))

    var grid_cell := get_grid_cell_from_coords(coords)
    if grid_cell:
        grid_cell.has_water = true
    else:
        set_grid_cell(coords, GridCellState.new(false, true))
        # todo: not sure about this. Maybe all grid cells are initialized with grid cell state so there's no null check. But the additional memory of doing this? I think I just need a better way of handling grid state
        # Perhaps one way is to declare a property on the actual tile map for tiles that can have state. Then when the region is initialized, it loops through the tilemap cells and creates grid state for tiles that can have state
        # And then only tiles that are interactable to begin with are the only ones with state

var tilled_soil_layer := 0
func place_tilled_soil_at_coords(coords: Vector2i) -> void:
    tilled_soil_tile_map.set_cell(tilled_soil_layer, coords, 0, Vector2i(1, 1))
    tilled_soil_tile_map.set_cells_terrain_connect(tilled_soil_layer, [coords], 0, 0)
    set_grid_cell(coords, GridCellState.new(true, false))


func expire_water_at_coords(coords: Vector2i) -> void:
    tilled_soil_tile_map.erase_cell(watered_soil_layer, coords)
    get_grid_cell_from_coords(coords).has_water = false


func get_crop_at_coords(coords: Vector2i) -> Crop:
    var region_crops := get_tree().get_nodes_in_group(crops_group_name)
    for crop in region_crops:
        # todo: cast to Crop type
        if crop.region_coords == coords:
            return crop
    return null


func get_storage_at_coords(coords: Vector2i) -> StorageContainer:
    var region_crops := get_tree().get_nodes_in_group(storage_group_name)
    for crop in region_crops:
        # todo: cast to Crop type
        if crop.region_coords == coords:
            return crop
    return null


var cat_worker_packed_scene := preload("res://scenes/character.tscn")
func add_cat_worker() -> void:
    var cat_worker_instance := cat_worker_packed_scene.instantiate()
    cat_worker_instance.region = self
    cat_worker_instance.position = Vector2(200, 200)
    add_child(cat_worker_instance)
    cat_worker_instance.add_to_group(cats_group_name)


var storage_container_packed_scene := preload("res://scenes/objects/storage_container.tscn")
func add_storage_container(coords: Vector2i) -> void:
    var storage_container_instance := storage_container_packed_scene.instantiate()
    storage_container_instance.region = self
    storage_container_instance.position = ground_tile_map.map_to_local(coords)
    add_child(storage_container_instance)
    storage_container_instance.add_to_group(storage_group_name)


func debug_seed_grid() -> void:
    place_tilled_soil_at_coords(Vector2i(15, 11))
    place_tilled_soil_at_coords(Vector2i(16, 11))
    place_tilled_soil_at_coords(Vector2i(17, 11))
    place_tilled_soil_at_coords(Vector2i(15, 12))
    place_tilled_soil_at_coords(Vector2i(16, 12))
    place_tilled_soil_at_coords(Vector2i(17, 12))
