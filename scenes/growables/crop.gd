extends Node2D

class_name Crop

@export
var growthDurationInSeconds := 15.0
@export
var growthStages := 3 # 3 growing frames, 1 harvest frame
@export
var coin_reward: int
var currentGrowthDurationInSeconds := 0.0
var currentGrowthStage := 1
var timePerGrowthStage : float
var completedGrowing := false
var region: Region
var region_coords: Vector2i
var crop_type: Global.CROP_TYPE

var water: WateredSoil:
    get:
        return water
    set(value):
        water = value
        water.water_has_expired.connect(_on_water_has_expired)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # Place in on ready to take in exported variable changes
    timePerGrowthStage = growthDurationInSeconds / growthStages
    region_coords = region.get_grid_coords_from_pos(position)
    _on_water_has_expired()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if !completedGrowing and water != null:
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
            print("Creating harvest job for %s at %s" % [Global.CROP_TYPE.keys()[crop_type], region.get_grid_coords_from_pos(position)])
            region.job_queue.push(HarvestJob.new(position, self))

func hasEnteredNextGrowthStage() -> bool:
    var upperDurationLimit := timePerGrowthStage * currentGrowthStage
    if currentGrowthDurationInSeconds >= upperDurationLimit:
        return true
    return false

func checkHasCompletedGrowing() -> bool:
    if currentGrowthDurationInSeconds >= growthDurationInSeconds:
        return true
    return false


func _on_water_has_expired() -> void:
    if completedGrowing:
        return
    region.job_queue.push(WaterJob.new(position, self))


func harvest(harvested_by: Node2D) -> void:
    region.get_grid_cell_from_pos(position).is_plottable = true

    ($AnimatedSprite2D as Node2D).hide()
    region.remove_child(self)
    harvested_by.add_child(self)
    position = Vector2(0, -24)
    ($HarvestedSprite2D as Node2D).show()


func recieve_reward() -> void:
    print("Recieved reward of %s coins" % coin_reward)
    Player.coins += coin_reward
