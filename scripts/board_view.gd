extends VBoxContainer
class_name BoardView

signal slot_pressed(row: int, col: int)

var slot_buttons: Array[Array] = []


func setup(row_pattern: Array[int]) -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_theme_constant_override(UIConfig.THEME_SEPARATION, UIConfig.ROW_SEPARATION)

	_build_board(row_pattern)


func refresh(game: GameState) -> void:
	for row_index in range(slot_buttons.size()):
		for col_index in range(slot_buttons[row_index].size()):
			var button: Button = slot_buttons[row_index][col_index]
			var slot: Dictionary = game.get_slot(row_index, col_index)
			var card: Dictionary = slot[GameState.SLOT_KEY_CARD]
			var attack_cards: Array = slot[GameState.SLOT_KEY_ATTACK_CARDS]

			if card.is_empty():
				button.text = UIConfig.EMPTY_TEXT
				UIStyle.apply_empty_button(button)
				button.disabled = true

			elif not game.is_slot_uncovered(row_index, col_index):
				button.text = UIConfig.TEXT_HIDDEN
				UIStyle.apply_hidden_button(button)
				button.disabled = true

			elif CardUtils.is_loot(card):
				button.text = CardUtils.card_text(card) + "\n\n" + UIConfig.TEXT_TAKE_LOOT
				UIStyle.apply_loot_button(button, card)
				button.disabled = game.game_finished

			else:
				button.text = _monster_button_text(card, attack_cards)
				UIStyle.apply_monster_button(button, card)
				button.disabled = game.game_finished


func get_slot_status_text(game: GameState, row: int, col: int) -> String:
	var slot: Dictionary = game.get_slot(row, col)
	var card: Dictionary = slot[GameState.SLOT_KEY_CARD]
	var attack_cards: Array = slot[GameState.SLOT_KEY_ATTACK_CARDS]

	if card.is_empty():
		return UIConfig.TEXT_SLOT_EMPTY_STATUS

	if not game.is_slot_uncovered(row, col):
		return UIConfig.TEXT_HIDDEN_STATUS

	if CardUtils.is_loot(card):
		return UIConfig.TEXT_LOOT_STATUS

	return UIConfig.TEXT_MONSTER_STATUS_FORMAT % [
		CardUtils.short_text(card),
		attack_cards.size()
	]


func _build_board(row_pattern: Array[int]) -> void:
	slot_buttons.clear()

	for row_index in range(row_pattern.size()):
		var amount: int = row_pattern[row_index]

		var row_container: HBoxContainer = HBoxContainer.new()
		row_container.alignment = BoxContainer.ALIGNMENT_CENTER
		row_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row_container.add_theme_constant_override(
			UIConfig.THEME_SEPARATION,
			UIConfig.ROW_SEPARATION
		)
		add_child(row_container)

		var row_buttons: Array[Button] = []

		for col_index in range(amount):
			var slot_button: Button = Button.new()
			slot_button.custom_minimum_size = UIConfig.SLOT_SIZE
			slot_button.text = UIConfig.TEXT_HIDDEN
			slot_button.pressed.connect(_on_slot_pressed.bind(row_index, col_index))

			row_container.add_child(slot_button)
			row_buttons.append(slot_button)

		slot_buttons.append(row_buttons)


func _on_slot_pressed(row: int, col: int) -> void:
	slot_pressed.emit(row, col)


func _monster_button_text(monster: Dictionary, attack_cards: Array) -> String:
	var text: String = CardUtils.card_text(monster)

	if attack_cards.is_empty():
		return text

	if _is_ready_for_trigger(attack_cards):
		text += UIConfig.TEXT_MONSTER_KILL_READY
		return text

	var current_damage: int = _attack_damage(attack_cards)
	var required_damage: int = CardUtils.monster_power(monster)

	text += UIConfig.TEXT_MONSTER_DAMAGE_FORMAT % [
		current_damage,
		required_damage
	]

	return text


func _attack_damage(attack_cards: Array) -> int:
	var damage: int = GameState.EMPTY_COUNT
	var max_damage_cards: int = min(
		attack_cards.size(),
		GameState.POWER_ATTACK_CARD_COUNT
	)

	for attack_card_index in range(max_damage_cards):
		var card: Dictionary = attack_cards[attack_card_index]
		damage += CardUtils.power_value(card)

	return damage


func _is_ready_for_trigger(attack_cards: Array) -> bool:
	return attack_cards.size() == GameState.POWER_ATTACK_CARD_COUNT
