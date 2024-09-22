extends Node2D
# todo: Change the autoload from a scene to a script

var coins : int:
    get:
        return coins
    set(value):
        coins = value
        GlobalSignals.emit_player_coins_changed(coins)

var wood : int:
    get:
        return wood
    set(value):
        wood = value
        print("Player wood changed to %s" % wood)
        GlobalSignals.emit_player_wood_changed(wood)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    coins = Global.settings.player_starting_coins
    wood = Global.settings.player_starting_wood
    GlobalSignals.player_ability_unlocked.connect(unlock_ability)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_event := event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            spawn_particles_at_mouse()
            # get_viewport().set_input_as_handled()

#region Unlocked Abilities
var _unlocked_abilities := {
    Global.ABILITY_TYPE.AXE: false,
    Global.ABILITY_TYPE.PICKAXE: false,
}


func unlock_ability(ability: Global.ABILITY_TYPE) -> void:
    print("Player unlocked ability: %s" % ability)
    _unlocked_abilities[ability] = true


func is_ability_unlocked(ability: Global.ABILITY_TYPE) -> bool:
    return _unlocked_abilities[ability]
#endregion


#region Player Actions
enum SELECTED_ACTION {
    NONE,
    TILL_SOIL,
    DESTROY_TILLED_SOIL,
    PLANT_CROP,
}
var selected_action: SELECTED_ACTION = SELECTED_ACTION.NONE

func unset_current_action() -> void:
    match selected_action:
        SELECTED_ACTION.TILL_SOIL:
            unset_till_soil_action()
        SELECTED_ACTION.PLANT_CROP:
            unset_plant_crop_action()
        # SELECTED_ACTION.DESTROY_TILLED_SOIL:
        #     unset_destroy_tilled_soil_action()
        SELECTED_ACTION.NONE:
            pass


#region Till Soil Action
var till_soil_action_scene := preload("res://scenes/ui/plant_menu/till_soil_action.tscn")
var till_soil_action: TillSoilAction = null # Populated if Player.selected_action == Player.SELECTED_ACTION.TILL_SOIL
func set_till_soil_action() -> void:
    if selected_action != SELECTED_ACTION.NONE:
        unset_current_action()
    
    till_soil_action = till_soil_action_scene.instantiate() as TillSoilAction
    get_tree().get_first_node_in_group(Global.UI_GROUP_NAME).add_child(till_soil_action)
    selected_action = Player.SELECTED_ACTION.TILL_SOIL


func unset_till_soil_action() -> void:
    if till_soil_action:
        till_soil_action.queue_free()
        till_soil_action = null
        selected_action = SELECTED_ACTION.NONE
#endregion

#region Plant Crop Action
var plant_crop_action_scene := preload("res://scenes/ui/plant_menu/plant_crop_action.tscn")
var plant_crop_action: PlantCropAction = null # Populated if Player.selected_action == Player.SELECTED_ACTION.PLANT_CROP
func set_plant_crop_action(crop_type: Global.CROP_TYPE) -> void:
    if selected_action != SELECTED_ACTION.NONE:
        unset_current_action()
    
    plant_crop_action = plant_crop_action_scene.instantiate() as PlantCropAction
    plant_crop_action.as_crop_type(crop_type)
    get_tree().get_first_node_in_group(Global.UI_GROUP_NAME).add_child(plant_crop_action)
    selected_action = Player.SELECTED_ACTION.PLANT_CROP


func unset_plant_crop_action() -> void:
    if plant_crop_action:
        plant_crop_action.queue_free()
        plant_crop_action = null
        selected_action = SELECTED_ACTION.NONE
#endregion

#endregion

#region Click Particles
var click_particles : CPUParticles2D


var particles_packed_scene := preload("res://scenes/player/generic_splash_particle.tscn")
func spawn_particles_at_mouse() -> void:
    click_particles = particles_packed_scene.instantiate() as CPUParticles2D
    get_tree().root.add_child(click_particles)
    click_particles.position = get_global_mouse_position()
    click_particles.emitting = true
#endregion
