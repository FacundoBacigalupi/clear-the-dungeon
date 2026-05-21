extends VBoxContainer
class_name HandPanel

signal hand_card_pressed(index: int)
signal reserve_card_pressed(index: int)
signal reserve_setup_pressed
signal ability_pressed(index: int)
signal end_turn_pressed
signal diamond_top_pressed
signal diamond_leave_pressed

var hand_buttons: Array[Button] = []
var reserve_buttons: Array[Button] = []
var ability_buttons: Array[Button] = []

var reserve_label: Label
var ability_label: Label
var double_status_label: Label
var diamond_choice_label: Label
var diamond_top_button: Button
var diamond_leave_button: Button
var set_reserve_button: Button
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

	for hand_index in range(GameState.MAX_VISIBLE_HAND_CARDS):
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

	set_reserve_button = Button.new()
	set_reserve_button.custom_minimum_size = Vector2(
		UIConfig.DISCARD_BUTTON_WIDTH,
		UIConfig.DISCARD_BUTTON_HEIGHT
	)
	set_reserve_button.text = UIConfig.TEXT_SET_RESERVE
	UIStyle.apply_action_button(set_reserve_button)
	set_reserve_button.pressed.connect(_on_reserve_setup_pressed)
	add_child(set_reserve_button)

	_add_section_margin()

	reserve_label = Label.new()
	reserve_label.text = UIConfig.TEXT_POWER_RESERVE
	reserve_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(reserve_label)
	add_child(reserve_label)

	reserve_buttons.clear()

	for reserve_index in range(GameState.POWER_RESERVE_SIZE):
		var reserve_button: Button = Button.new()
		reserve_button.custom_minimum_size = Vector2(
			UIConfig.RESERVE_CARD_WIDTH,
			UIConfig.RESERVE_CARD_HEIGHT
		)
		reserve_button.text = UIConfig.TEXT_EMPTY
		UIStyle.apply_empty_button(reserve_button)
		reserve_button.pressed.connect(_on_reserve_card_pressed.bind(reserve_index))
		add_child(reserve_button)
		reserve_buttons.append(reserve_button)

	_add_section_margin()

	ability_label = Label.new()
	ability_label.text = UIConfig.TEXT_SPECIAL_ABILITIES
	ability_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(ability_label)
	add_child(ability_label)

	double_status_label = Label.new()
	double_status_label.text = UIConfig.TEXT_DOUBLE_PENDING
	double_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(double_status_label)
	add_child(double_status_label)

	ability_buttons.clear()

	for ability_index in range(CardUtils.SUITS.size()):
		var ability_button: Button = Button.new()
		ability_button.custom_minimum_size = Vector2(
			UIConfig.ABILITY_BUTTON_WIDTH,
			UIConfig.ABILITY_BUTTON_HEIGHT
		)
		ability_button.text = UIConfig.TEXT_EMPTY
		UIStyle.apply_empty_button(ability_button)
		ability_button.pressed.connect(_on_ability_pressed.bind(ability_index))
		add_child(ability_button)
		ability_buttons.append(ability_button)

	diamond_choice_label = Label.new()
	diamond_choice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(diamond_choice_label)
	add_child(diamond_choice_label)

	diamond_top_button = Button.new()
	diamond_top_button.custom_minimum_size = Vector2(
		UIConfig.ABILITY_BUTTON_WIDTH,
		UIConfig.ABILITY_BUTTON_HEIGHT
	)
	diamond_top_button.text = UIConfig.TEXT_DIAMOND_TOP
	UIStyle.apply_action_button(diamond_top_button)
	diamond_top_button.pressed.connect(_on_diamond_top_pressed)
	add_child(diamond_top_button)

	diamond_leave_button = Button.new()
	diamond_leave_button.custom_minimum_size = Vector2(
		UIConfig.ABILITY_BUTTON_WIDTH,
		UIConfig.ABILITY_BUTTON_HEIGHT
	)
	diamond_leave_button.text = UIConfig.TEXT_DIAMOND_LEAVE
	UIStyle.apply_action_button(diamond_leave_button)
	diamond_leave_button.pressed.connect(_on_diamond_leave_pressed)
	add_child(diamond_leave_button)

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


func refresh(game: GameState, selected_card_refs: Array[Dictionary]) -> void:
	_refresh_hand_buttons(game, selected_card_refs)
	_refresh_reserve_buttons(game, selected_card_refs)
	_refresh_ability_buttons(game)
	_refresh_diamond_choice(game)
	
	set_reserve_button.visible = game.power_reserve_setup_pending
	set_reserve_button.disabled = (
		game.game_finished
		or _selected_source_count(selected_card_refs, GameState.CARD_SOURCE_HAND) != GameState.POWER_RESERVE_SIZE
		or selected_card_refs.size() != GameState.POWER_RESERVE_SIZE
	)

	end_turn_button.disabled = game.game_finished or game.power_reserve_setup_pending


func _refresh_hand_buttons(game: GameState, selected_card_refs: Array[Dictionary]) -> void:
	var visible_hand_buttons: int = game.get_visible_hand_button_count()

	for hand_index in range(hand_buttons.size()):
		var button: Button = hand_buttons[hand_index]
		button.visible = hand_index < visible_hand_buttons

		if hand_index >= game.hand.size():
			button.text = UIConfig.TEXT_EMPTY
			UIStyle.apply_empty_button(button)
			button.disabled = true
			continue

		var card: Dictionary = game.hand[hand_index]
		var selected_order: int = _selected_order(
			selected_card_refs,
			GameState.CARD_SOURCE_HAND,
			hand_index
		)
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


func _refresh_reserve_buttons(game: GameState, selected_card_refs: Array[Dictionary]) -> void:
	var reserve_visible: bool = game.is_power_reserve_active()
	reserve_label.visible = reserve_visible

	for reserve_index in range(reserve_buttons.size()):
		var button: Button = reserve_buttons[reserve_index]
		button.visible = reserve_visible

		if reserve_index >= game.power_reserve.size():
			button.text = UIConfig.TEXT_EMPTY
			UIStyle.apply_empty_button(button)
			button.disabled = true
			continue

		var card: Dictionary = game.power_reserve[reserve_index]
		var selected_order: int = _selected_order(
			selected_card_refs,
			GameState.CARD_SOURCE_RESERVE,
			reserve_index
		)

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

		button.disabled = game.game_finished or game.power_reserve_setup_pending


func _refresh_ability_buttons(game: GameState) -> void:
	var abilities_visible: bool = game.is_special_abilities_active()
	ability_label.visible = abilities_visible
	double_status_label.visible = abilities_visible and game.double_next_attack_card

	for ability_index in range(ability_buttons.size()):
		var button: Button = ability_buttons[ability_index]
		button.visible = abilities_visible

		if ability_index >= game.king_inventory.size():
			button.text = UIConfig.TEXT_EMPTY
			UIStyle.apply_empty_button(button)
			button.disabled = true
			continue

		var king: Dictionary = game.king_inventory[ability_index]
		button.text = CardUtils.card_text(king)
		UIStyle.apply_hand_button(button, false, king)
		button.disabled = game.game_finished or game.power_reserve_setup_pending or game.diamond_ability_pending


func _refresh_diamond_choice(game: GameState) -> void:
	var choice_visible: bool = game.diamond_ability_pending

	diamond_choice_label.visible = choice_visible
	diamond_top_button.visible = choice_visible
	diamond_leave_button.visible = choice_visible

	if not choice_visible:
		return

	diamond_choice_label.text = UIConfig.TEXT_DIAMOND_BOTTOM_FORMAT % CardUtils.card_text(game.diamond_revealed_card)

	diamond_top_button.disabled = game.game_finished
	diamond_leave_button.disabled = game.game_finished


func _selected_order(selected_card_refs: Array[Dictionary], source: String, index: int) -> int:
	for selected_index in range(selected_card_refs.size()):
		var card_ref: Dictionary = selected_card_refs[selected_index]

		if card_ref[GameState.PLAY_REF_KEY_SOURCE] == source and card_ref[GameState.PLAY_REF_KEY_INDEX] == index:
			return selected_index

	return UIConfig.NOT_FOUND_INDEX


func _selected_source_count(selected_card_refs: Array[Dictionary], source: String) -> int:
	var count: int = GameState.EMPTY_COUNT

	for card_ref in selected_card_refs:
		if card_ref[GameState.PLAY_REF_KEY_SOURCE] == source:
			count += 1

	return count


func _add_section_margin() -> void:
	var margin: Control = Control.new()
	margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.SECTION_TOP_MARGIN
	)
	add_child(margin)


func _on_hand_card_pressed(index: int) -> void:
	hand_card_pressed.emit(index)


func _on_reserve_card_pressed(index: int) -> void:
	reserve_card_pressed.emit(index)


func _on_reserve_setup_pressed() -> void:
	reserve_setup_pressed.emit()


func _on_ability_pressed(index: int) -> void:
	ability_pressed.emit(index)


func _on_end_turn_pressed() -> void:
	end_turn_pressed.emit()


func _on_diamond_top_pressed() -> void:
	diamond_top_pressed.emit()


func _on_diamond_leave_pressed() -> void:
	diamond_leave_pressed.emit()
