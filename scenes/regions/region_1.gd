extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    region_name = "Region_1"
    ground_tile_map = $BrightGrassTileMap
    tilled_soil_tile_map = $TilledTileMap
    super()

    # Add the first cat worker
    add_cat_worker()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super(delta)

