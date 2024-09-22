extends FollowMouse

class_name PlantCropAction

var cost: int
var crop_type: Global.CROP_TYPE


func as_crop_type(type: Global.CROP_TYPE) -> void:
    match type:
        Global.CROP_TYPE.WHEAT:
            as_wheat()
        Global.CROP_TYPE.BEET:
            as_beet()
        Global.CROP_TYPE.LETTUCE:
            as_lettuce()


var wheat_seed_packet_texture := preload("res://assets/items/seeds/wheat_seeds.png")
func as_wheat() -> void:
    crop_type = Global.CROP_TYPE.WHEAT
    self.texture = wheat_seed_packet_texture
    cost = Global.CROP_COST[Global.CROP_TYPE.WHEAT]


var beet_seed_packet_texture := preload("res://assets/items/seeds/beet_seeds.png")
func as_beet() -> void:
    crop_type = Global.CROP_TYPE.BEET
    self.texture = beet_seed_packet_texture
    cost = Global.CROP_COST[Global.CROP_TYPE.BEET]


var lettuce_seed_packet_texture := preload("res://assets/items/seeds/lettuce_seeds.png")
func as_lettuce() -> void:
    crop_type = Global.CROP_TYPE.LETTUCE
    self.texture = lettuce_seed_packet_texture
    cost = Global.CROP_COST[Global.CROP_TYPE.LETTUCE]
