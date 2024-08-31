extends Node2D

var region: Region
var region_coords: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    region_coords = region.get_grid_coords_from_pos(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func open() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.play("open")
    animation.animation_finished.connect(_on_open_animation_finished)

func _on_open_animation_finished() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.animation_finished.disconnect(_on_open_animation_finished)
    animation.play_backwards("open")