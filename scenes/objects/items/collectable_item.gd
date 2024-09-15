extends Resource

class_name CollectableItem

@export var name: String = ""
@export var texture: Texture2D
@export var radius: int
@export var coin_reward: int
@export var wood_reward: int


func recieve_reward() -> void:
    # print("Recieved reward of %s coins" % coin_reward)
    Player.coins += coin_reward
    Player.wood += wood_reward