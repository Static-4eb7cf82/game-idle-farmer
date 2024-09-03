extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super()

    # Add the first cat worker
    add_cat_worker(Vector2(200, 200))
    # add_cat_worker(Vector2(216, 200))
    add_storage_container(Vector2i(15, 8))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super(delta)

