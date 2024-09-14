extends StaticBody2D

class_name WoodTree

@export var harvestDurationInSeconds: int = 5
@export var regenDurationInSeconds: int = 60
@export var drop_item_data : CollectableItem
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fall_animation: AnimatedSprite2D = $FallAnimation
@onready var harvest_timer: Timer = $HarvestTimer
@onready var regen_timer: Timer = $RegenTimer

@export var region: Region
var harvest_finished := false
signal item_dropped(item: DroppedItem)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # first time setup
    harvest_timer.wait_time = harvestDurationInSeconds
    regen_timer.wait_time = regenDurationInSeconds

    # re-occuring setup
    setup_for_harvest()


func setup_for_harvest() -> void:
    fall_animation.hide()
    animated_sprite_2d.show()
    animated_sprite_2d.play("idle")
    harvest_finished = false
    ready_for_harvest()


func ready_for_harvest() -> void:
    region.job_queue.push(ChopTreeJob.new(position, self))


func start_harvest() -> void:
    harvest_timer.start()


func on_hit() -> void:
    animated_sprite_2d.play("hit")
    await animated_sprite_2d.animation_finished
    animated_sprite_2d.play("idle")


func _on_harvest_timer_timeout() -> void:
    # Done harvesting
    harvest_finished = true

    # Wait for current hit animation to finish
    if animated_sprite_2d.animation == "hit":
        await animated_sprite_2d.animation_finished

    # Make tree fall over
    fall_animation.stop() # reset to beginning
    fall_animation.show()
    animated_sprite_2d.hide()
    fall_animation.play("fall")

    await fall_animation.animation_finished
    fall_animation.hide()
    drop_item()
    regen_timer.start()


var dropped_item_scene := preload("res://scenes/objects/items/dropped_item.tscn")
func drop_item() -> void:
    var dropped_item := dropped_item_scene.instantiate() as DroppedItem
    dropped_item.item = drop_item_data
    add_child(dropped_item)
    dropped_item.position = Vector2(0, 24)
    item_dropped.emit(dropped_item)


func _on_regen_timer_timeout() -> void:
    setup_for_harvest()