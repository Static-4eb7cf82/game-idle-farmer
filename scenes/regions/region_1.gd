extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super()

    # Add the first cat worker
    add_cat_worker(Vector2(200, 200))
    # add_cat_worker(Vector2(216, 200))
    add_storage_container(Vector2i(15, 4))
    # add_storage_container(Vector2i(10, 4))
    add_water_well(Vector2i(23, 9))
    
    debug_seed_tilled_soil()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super(delta)


func debug_seed_tilled_soil() -> void:
    place_tilled_soil_at_coords(Vector2i(14, 10))
    place_tilled_soil_at_coords(Vector2i(15, 10))
    place_tilled_soil_at_coords(Vector2i(16, 10))
    place_tilled_soil_at_coords(Vector2i(17, 10))
    place_tilled_soil_at_coords(Vector2i(14, 11))
    place_tilled_soil_at_coords(Vector2i(15, 11))
    place_tilled_soil_at_coords(Vector2i(16, 11))
    place_tilled_soil_at_coords(Vector2i(17, 11))
    place_tilled_soil_at_coords(Vector2i(14, 12))
    place_tilled_soil_at_coords(Vector2i(15, 12))
    place_tilled_soil_at_coords(Vector2i(16, 12))
    place_tilled_soil_at_coords(Vector2i(17, 12))

