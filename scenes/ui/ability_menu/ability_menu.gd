extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel.text = str(Global.settings.ability_axe_cost)
    $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel.text = str(Global.settings.ability_pickaxe_cost)