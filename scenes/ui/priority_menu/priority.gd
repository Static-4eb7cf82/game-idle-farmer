extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var tree := $MarginContainer/PriorityTree as Tree
    
    var root := tree.create_item()
    tree.hide_root = true

    var item_build := tree.create_item(root)
    item_build.set_text(0, ":: BUILD")
    var item_build_till := tree.create_item(item_build)
    item_build_till.set_text(0, ":: TILL SOIL")
    var item_build_construct := tree.create_item(item_build)
    item_build_construct.set_text(0, ":: CONSTRUCT")
    
    var item_water := tree.create_item(root)
    item_water.set_text(0, ":: WATER")
    
    var item_harvest := tree.create_item(root)
    item_harvest.set_text(0, ":: HARVEST")
    var item_harvest_plants := tree.create_item(item_harvest)
    item_harvest_plants.set_text(0, ":: PLANTS")
    var item_harvest_wood := tree.create_item(item_harvest)
    item_harvest_wood.set_text(0, ":: WOOD")
    var item_harvest_stone := tree.create_item(item_harvest)
    item_harvest_stone.set_text(0, ":: STONE")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
