extends StaticBody2D

class_name WoodTree

@export var region: Region
@export var drop_item_data : CollectableItem
@onready var max_hp: int = Global.settings.wood_tree_max_hp
@onready var regen_duration_in_seconds: int = Global.settings.wood_tree_regen_duration_in_seconds
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fall_animation: AnimatedSprite2D = $FallAnimation
@onready var regen_timer: Timer = $RegenTimer

var hp: int
var harvest_finished := false
signal item_dropped(item: DroppedItem)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # first time setup
    regen_timer.wait_time = regen_duration_in_seconds

    # re-occuring setup
    setup_for_harvest()

    GlobalSignals.player_ability_unlocked.connect(on_ability_unlocked)


func is_growing() -> bool:
    return !regen_timer.is_stopped()


func setup_for_harvest() -> void:
    hp = max_hp
    fall_animation.hide()
    animated_sprite_2d.show()
    animated_sprite_2d.play("idle")
    harvest_finished = false

    if Player.is_ability_unlocked(Global.ABILITY_TYPE.AXE):
        notify_ready_for_harvest()


func notify_ready_for_harvest() -> void:
    region.job_queue.push(ChopTreeJob.new(position, self))


func on_hit() -> void:
    hp -= 1
    if hp <= 0:
        harvest_finished = true

    animated_sprite_2d.play("hit")
    await animated_sprite_2d.animation_finished
    animated_sprite_2d.play("idle")

    if hp <= 0:
        fell_tree()


func fell_tree() -> void:
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
    dropped_item.position = Vector2(-16, -4)
    item_dropped.emit(dropped_item)


func _on_regen_timer_timeout() -> void:
    setup_for_harvest()


func on_ability_unlocked(ability: Global.ABILITY_TYPE) -> void:
    if ability == Global.ABILITY_TYPE.AXE and !is_growing():
        notify_ready_for_harvest()