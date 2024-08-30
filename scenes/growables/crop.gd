extends Node2D

class_name Crop

@export
var growthDurationInSeconds := 15.0
@export
var growthStages := 3 # 3 growing frames, 1 harvest frame
var currentGrowthDurationInSeconds := 0.0
var currentGrowthStage := 1
var timePerGrowthStage : float
var completedGrowing := false
var region: Region
var region_coords: Vector2i
var crop_type: Global.CROP_TYPE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Place in on ready to take in exported variable changes
    timePerGrowthStage = growthDurationInSeconds / growthStages
    region_coords = region.get_grid_coords_from_pos(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if !completedGrowing and hasWater():
        # print("Growing: ", currentGrowthDurationInSeconds)
        currentGrowthDurationInSeconds += delta
        if hasEnteredNextGrowthStage():
            # print("Entered next growth stage")
            currentGrowthStage += 1
            ($AnimatedSprite2D as AnimatedSprite2D).frame = currentGrowthStage - 1
        if checkHasCompletedGrowing():
            print("%s at %s completed growing" % [Global.CROP_TYPE.keys()[crop_type], region.get_grid_coords_from_pos(position)])
            completedGrowing = true
            ($AnimatedSprite2D as AnimatedSprite2D).frame = growthStages
            # Set to available for harvest

func hasEnteredNextGrowthStage() -> bool:
    var upperDurationLimit := timePerGrowthStage * currentGrowthStage
    if currentGrowthDurationInSeconds >= upperDurationLimit:
        return true
    return false

func checkHasCompletedGrowing() -> bool:
    if currentGrowthDurationInSeconds >= growthDurationInSeconds:
        return true
    return false

func hasWater() -> bool:
    var grid_cell := region.get_grid_cell_from_coords(region_coords)
    if grid_cell and grid_cell.has_water:
        # print("Has water")
        return true
    return false
