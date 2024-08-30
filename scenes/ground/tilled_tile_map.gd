extends TileMap

var region: Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    region = get_parent() as Region
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    
    # first check if player global has seeds selected before doing further calculations
    if Player.selected_seed_type == Global.CROP_TYPE.NONE:
        return
    # on click on tilled tilemap
    # if cell exists, and is_plottable, plant seed
    # when the crop is harvested, remember to set the cell back to is_plottable = true

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

        var clicked_tilemap_coords := self.local_to_map(self.get_local_mouse_position())
        var clicked_grid_cell := region.get_grid_cell_from_coords(clicked_tilemap_coords)
        if clicked_grid_cell and clicked_grid_cell.is_plottable:
            # instantiate the crop type that the player has selected at these coords
            # Plant it and set input as handled
            plant_crop(Player.selected_seed_type, self.map_to_local(clicked_tilemap_coords))
            clicked_grid_cell.is_plottable = false

var wheat_crop_scene := preload("res://scenes/growables/wheat.tscn")
var beet_crop_scene := preload("res://scenes/growables/beet.tscn")
var lettuce_crop_scene := preload("res://scenes/growables/lettuce.tscn")
var carrot_crop_scene := preload("res://scenes/growables/carrot.tscn")
func plant_crop(crop_type: Global.CROP_TYPE, pos: Vector2) -> void:
    var crop_packed_scene: PackedScene
    match crop_type:
        Global.CROP_TYPE.WHEAT:
            crop_packed_scene = wheat_crop_scene
        Global.CROP_TYPE.BEET:
            crop_packed_scene = beet_crop_scene
        Global.CROP_TYPE.LETTUCE:
            crop_packed_scene = lettuce_crop_scene
        Global.CROP_TYPE.CARROT:
            crop_packed_scene = carrot_crop_scene

    if crop_packed_scene:
        var instance := crop_packed_scene.instantiate() as Crop
        instance.position = pos
        instance.region = region
        instance.crop_type = crop_type
        add_child(instance)
