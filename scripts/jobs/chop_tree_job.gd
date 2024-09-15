extends Job

class_name ChopTreeJob

# Who is being harvested
var _subject: WoodTree

func _init(job_pos: Vector2, subject: WoodTree) -> void:
    type = JOB_TYPE.CHOP_TREE
    category = JOB_CATEGORY.HARVEST_WOOD
    pos = job_pos
    _subject = subject
