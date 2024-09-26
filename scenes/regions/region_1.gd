extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super()
    
    set_initial_state()


func set_initial_state() -> void:

    # Add the first cat worker
    add_cat_worker(Vector2(200, 200))
    # add_cat_worker(Vector2(216, 200))
    # add_storage_container(Vector2i(24, 9))
    add_storage_container(Vector2i(8, 11))
    add_water_well(Vector2i(5, 15))

    place_tilled_soil_at_coords(Vector2i(13, 13))
    place_tilled_soil_at_coords(Vector2i(14, 13))
    place_tilled_soil_at_coords(Vector2i(15, 13))
    place_tilled_soil_at_coords(Vector2i(16, 13))
    place_tilled_soil_at_coords(Vector2i(13, 14))
    place_tilled_soil_at_coords(Vector2i(14, 14))
    place_tilled_soil_at_coords(Vector2i(15, 14))
    place_tilled_soil_at_coords(Vector2i(16, 14))
    place_tilled_soil_at_coords(Vector2i(13, 15))
    place_tilled_soil_at_coords(Vector2i(14, 15))
    place_tilled_soil_at_coords(Vector2i(15, 15))
    place_tilled_soil_at_coords(Vector2i(16, 15))

