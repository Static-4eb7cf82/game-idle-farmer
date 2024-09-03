class_name Job


# Specific job types. Could even be considered their names
enum JOB_TYPE {
    TILL,
    WATER,
    HARVEST,
    BUILD_WORKBENCH,
}

# Broader job category
enum JOB_CATEGORY {
    WATER,
    HARVEST,
    BUILD,
}

# Job state
var type: JOB_TYPE
var category: JOB_CATEGORY
var pos: Vector2