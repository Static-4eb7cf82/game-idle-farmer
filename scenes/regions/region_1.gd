extends Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super()

    # Add the first cat worker
    add_cat_worker(Vector2(200, 200))
    add_cat_worker(Vector2(216, 200))
    add_storage_container(Vector2i(15, 4))
    add_storage_container(Vector2i(10, 4))
    self.till_cost = Global.settings.region_1_till_cost


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super(delta)

