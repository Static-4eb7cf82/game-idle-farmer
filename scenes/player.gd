extends Node2D
# todo: Change the autoload from a scene to a script

var particles_packed_scene := preload("res://scenes/generic_splash_particle.tscn")
var click_particles : CPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    click_particles = particles_packed_scene.instantiate() as CPUParticles2D
    click_particles.emitting = false
    add_child(click_particles)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

var selected_seed_type: Global.crop_type = Global.crop_type.NONE
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_event := event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            print("[Player] Mouse down at: ", get_global_mouse_position())
            click_particles.position = get_global_mouse_position()
            click_particles.emitting = true
            # get_viewport().set_input_as_handled()