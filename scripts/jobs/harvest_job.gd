extends Job

class_name HarvestJob

# Who is being harvested
var _subject: Crop

func _init(job_pos: Vector2, subject: Crop) -> void:
    type = JOB_TYPE.HARVEST
    category = JOB_CATEGORY.HARVEST
    pos = job_pos
    _subject = subject
