extends Node2D

class_name StorageContainer

var region: Region


func open() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.play("open")
    await animation.animation_finished


func close() -> void:
    var animation := $AnimatedSprite2D as AnimatedSprite2D
    animation.play_backwards("open")
