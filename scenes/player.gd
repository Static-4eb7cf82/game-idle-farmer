extends Node2D
# todo: Change the autoload from a scene to a script

var coins : int:
    get:
        return coins
    set(value):
        coins = value
        GlobalSignals.emit_player_coins_changed(coins)


var click_particles : CPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    coins = 100

var till_soil_selected := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

var selected_seed_packet: SelectedSeedPacket = null
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_event := event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            spawn_particles_at_mouse()
            # get_viewport().set_input_as_handled()


var particles_packed_scene := preload("res://scenes/generic_splash_particle.tscn")
func spawn_particles_at_mouse() -> void:
    click_particles = particles_packed_scene.instantiate() as CPUParticles2D
    add_child(click_particles)
    click_particles.position = get_global_mouse_position()
    click_particles.emitting = true