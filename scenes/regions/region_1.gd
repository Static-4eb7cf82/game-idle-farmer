extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    region_name = "Region 1"
    ground_tile_map = $BrightGrassTileMap
    super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super(delta)
