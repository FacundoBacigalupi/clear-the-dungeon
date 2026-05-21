extends VBoxContainer
class_name HandPanel

signal hand_card_pressed(index: int)
signal end_turn_pressed

var hand_buttons: Array[Button] = []
var end_turn_button: Button


func setup() -> void:
	custom_minimum_size = Vector2(UIConfig.RIGHT_PANEL_WIDTH, UIConfig.ZERO_FLOAT)
	add_theme_constant_override(UIConfig.THEME_SEPARATION, UIConfig.PANEL_SEPARATION)

	var hand_label: Label = Label.new()
	hand_label.text = UIConfig.TEXT_HAND
	hand_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(hand_label)
	add_child(hand_label)

	hand_buttons.clear()

	for hand_index in range(GameState.HAND_SIZE):
		var card_button: Button = Button.new()
		card_button.custom_minimum_size = Vector2(
			UIConfig.HAND_CARD_WIDTH,
			UIConfig.HAND_CARD_HEIGHT
		)
		card_button.text = UIConfig.TEXT_EMPTY
		UIStyle.apply_empty_button(card_button)
		card_button.pressed.connect(_on_hand_card_pressed.bind(hand_index))
		add_child(card_button)
		hand_buttons.append(card_button)

	var end_turn_margin: Control = Control.new()
	end_turn_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.END_TURN_TOP_MARGIN
	)
	add_child(end_turn_margin)

	end_turn_button = Button.new()
	end_turn_button.custom_minimum_size = Vector2(
		UIConfig.DISCARD_BUTTON_WIDTH,
		UIConfig.DISCARD_BUTTON_HEIGHT
	)
	end_turn_button.text = UIConfig.TEXT_END_TURN
	UIStyle.apply_action_button(end_turn_button)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	add_child(end_turn_button)


func refresh(game: GameState, selected_hand_indices: Array[int]) -> void:
	for hand_index in range(hand_buttons.size()):
		var button: Button = hand_buttons[hand_index]

		if hand_index >= game.hand.size():
			button.text = UIConfig.TEXT_EMPTY
			UIStyle.apply_empty_button(button)
			button.disabled = true
			continue

		var card: Dictionary = game.hand[hand_index]
		var selected_order: int = selected_hand_indices.find(hand_index)
		UIStyle.apply_hand_button(
			button,
			selected_order != UIConfig.NOT_FOUND_INDEX,
			card
		)

		if selected_order == UIConfig.NOT_FOUND_INDEX:
			button.text = CardUtils.card_text(card)
		else:
			button.text = UIConfig.TEXT_SELECTED_CARD_FORMAT % [
				selected_order + UIConfig.DISPLAY_INDEX_OFFSET,
				CardUtils.card_text(card)
			]

		button.disabled = game.game_finished

	end_turn_button.disabled = game.game_finished


func _on_hand_card_pressed(index: int) -> void:
	hand_card_pressed.emit(index)


func _on_end_turn_pressed() -> void:
	end_turn_pressed.emit()
