# A FIFO queue for jobs
class_name JobQueue

var _job_queue: Array[Job] = []

func push(job: Job) -> void:
    _job_queue.append(job)

func pop() -> Job:
    return _job_queue.pop_front()

func pop_by_category(category: Job.JOB_CATEGORY) -> Job:
    for i in range(_job_queue.size()):
        if _job_queue[i].category == category:
            var job := _job_queue[i]
            _job_queue.remove_at(i)
            return job
    
    return null

func is_empty() -> bool:
    return _job_queue.size() == 0