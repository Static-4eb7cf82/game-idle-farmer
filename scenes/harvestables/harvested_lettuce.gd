extends HarvestableItem


func recieve_reward() -> void:
    print("Recieved reward of %s coins" % coin_reward)
    Player.coins += coin_reward