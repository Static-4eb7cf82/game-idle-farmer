extends PanelContainer


var check_mark_texture : Texture = preload("res://assets/ui/small_check_mark.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel.text = str(Global.settings.ability_axe_cost)
    $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel.text = str(Global.settings.ability_pickaxe_cost)


func _on_axe_button_pressed() -> void:
    if Player.coins >= Global.settings.ability_axe_cost:
        Player.coins -= Global.settings.ability_axe_cost
        set_ability_acquired(
            $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button,
            $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button/MarginContainer/VBoxContainer/TextureRect,
            $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinTexture,
            $MarginContainer/ScrollContainer/HBoxContainer/Axe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel)
        GlobalSignals.emit_player_ability_unlocked(Global.ABILITY_TYPE.AXE)


func _on_pickaxe_button_pressed() -> void:
    if Player.coins >= Global.settings.ability_pickaxe_cost:
        Player.coins -= Global.settings.ability_pickaxe_cost
        set_ability_acquired(
            $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button,
            $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button/MarginContainer/VBoxContainer/TextureRect,
            $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinTexture,
            $MarginContainer/ScrollContainer/HBoxContainer/Pickaxe/Button/MarginContainer/VBoxContainer/HBoxContainer/CoinCostLabel)
        GlobalSignals.emit_player_ability_unlocked(Global.ABILITY_TYPE.PICKAXE)


func set_ability_acquired(button: Button, ability_texture_rect: TextureRect, coin_texture: TextureRect, coin_cost_label: Label) -> void:
    button.disabled = true
    button.mouse_default_cursor_shape = CURSOR_ARROW
    coin_texture.texture = check_mark_texture
    coin_cost_label.text = ""
    ability_texture_rect.modulate = Color(0.5, 0.5, 0.5, 1)