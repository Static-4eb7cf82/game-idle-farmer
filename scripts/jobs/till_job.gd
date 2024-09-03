extends Job

class_name TillJob

func _init(job_pos: Vector2) -> void:
    type = JOB_TYPE.TILL
    category = JOB_CATEGORY.BUILD
    pos = job_pos
