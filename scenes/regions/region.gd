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
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func init() -> void:
    var dimensions := ground_tile_map.get_used_rect().size
    for y in dimensions.y:
        grid.append([])
        for x in dimensions.x:
            grid[y].append(null)
    
    debug_seed_grid()


func set_grid_cell(pos: Vector2i, cell_state: GridCellState) -> void:
    grid[pos.y][pos.x] = cell_state


func get_grid_cell(pos: Vector2i) -> GridCellState:
    if pos.y < grid.size() and pos.x < grid[0].size():
        return grid[pos.y][pos.x]
    else:
        return null


func debug_seed_grid() -> void:
    set_grid_cell(Vector2i(15, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(16, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(17, 11), GridCellState.new(true))
    set_grid_cell(Vector2i(15, 12), GridCellState.new(true))
    set_grid_cell(Vector2i(16, 12), GridCellState.new(true))
    set_grid_cell(Vector2i(17, 12), GridCellState.new(true))
