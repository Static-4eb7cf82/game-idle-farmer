extends Node2D

class_name StorageContainer

var region: Region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func open() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.play("open")
    await animation.animation_finished


func close() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.play_backwards("open")
