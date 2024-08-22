extends Node2D

class_name Region

var region_name: String
var ground_tile_map: TileMap
var grid: Array

class GridCellState:
    
    func _init(val: bool) -> void:
        self.is_plottable = val

    # is_plottable doubles as being a tile possible to hold a crop as well as being occupied by a crop
    # corner tilled tiles will always be false, but inner tiles will be true by default
    var is_plottable: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var dimensions := ground_tile_map.get_used_rect().size
    for y in dimensions.y:
        grid.append([])
        for x in dimensions.x:
            grid[y].append(null)
    
    debug_seed_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func set_grid_cell(pos: Vector2i, cell_state: GridCellState) -> void:
    grid[pos.y][pos.x] = cell_state


func get_grid_coords_at_mouse() -> Vector2i:
    var coords := get_grid_coords_from_pos(ground_tile_map.get_global_mouse_position())
    print("Grid coords at mouse: ", coords)
    return coords


func get_grid_cell_at_mouse() -> GridCellState:
    return get_grid_cell_from_coords(get_grid_coords_at_mouse())


func get_grid_coords_from_pos(pos: Vector2) -> Vector2i:
    var coords := ground_tile_map.local_to_map(pos)
    return coords


func get_grid_cell_from_coords(pos: Vector2i) -> GridCellState:
    if pos.y < grid.size() and pos.x < grid[0].size():
        return grid[pos.y][pos.x]
    else:
        return null


var cat_worker_packed_scene := preload("res://scenes/character.tscn")
func add_cat_worker() -> void:
    var cat_worker_instance := cat_worker_packed_scene.instantiate()
    cat_worker_instance.region = self
    cat_worker_instance.position = Vector2(100, 100)
    add_child(cat_worker_instance)
    cat_worker_instance.add_to_group("%s_cat_workers" % region_name)

func debug_seed_grid() -> void:
    set_grid_cell(Vector2i(15, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(16, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(17, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(15, 12), GridCellState.new(true))
    set_grid_cell(Vector2i(16, 12), GridCellState.new(true))
    set_grid_cell(Vector2i(17, 12), GridCellState.new(true))
