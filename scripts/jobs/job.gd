class_name Job


# Specific job types. Could even be considered their names
enum JOB_TYPE {
    TILL,
    WATER,
    HARVEST,
    CHOP_TREE,
    BUILD_WORKBENCH,
}

# Broader job category, can be prioritized
enum JOB_CATEGORY {
    WATER,
    HARVEST,
    TILL,
    BUILD,
}

# Job state
var type: JOB_TYPE
var category: JOB_CATEGORY
var pos: Vector2