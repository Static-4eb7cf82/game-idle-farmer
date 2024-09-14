extends Area2D

class_name DroppedItem

@export var item: CollectableItem
signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    ($Sprite2D as Sprite2D).texture = item.texture


func _on_body_entered(body:Node2D) -> void:
    pass
    # if body is CatWorker:
    #     give_to(body as CatWorker)


func give_to(cat_worker: CatWorker) -> void:
    
    var tween := get_tree().create_tween()
    tween.tween_property(self, "global_position", cat_worker.global_position, 1).set_trans(Tween.TRANS_QUART)
    tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 0.3)

    await tween.finished

    cat_worker.collect_item(item)
    collected.emit()
    queue_free()
