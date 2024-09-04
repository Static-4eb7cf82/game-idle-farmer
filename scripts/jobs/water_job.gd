extends Job

class_name WaterJob

# Who is receiving the water
var _subject: Crop

func _init(job_pos: Vector2, subject: Crop) -> void:
    type = JOB_TYPE.WATER
    category = JOB_CATEGORY.WATER
    pos = job_pos
    _subject = subject
