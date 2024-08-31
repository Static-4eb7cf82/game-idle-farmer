extends TileMap

var region: Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    region = get_parent() as Region


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    
    # first check if player global has seeds selected before doing further calculations
    if not Player.selected_seed_packet:
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
            if Player.coins < Player.selected_seed_packet.price:
                print("Not enough coins to plant this crop")
                return
            region.plant_crop(Player.selected_seed_packet, self.map_to_local(clicked_tilemap_coords))
            clicked_grid_cell.is_plottable = false
