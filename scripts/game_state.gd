extends RefCounted
class_name GameState

const NO_LAYOUT_ID: String = ""
const JOKER_COUNT: int = 2

const ROW_ONE_AMOUNT: int = 1
const ROW_TWO_AMOUNT: int = 2
const ROW_THREE_AMOUNT: int = 3
const ROW_FOUR_AMOUNT: int = 2
const ROW_FIVE_AMOUNT: int = 1
const ROW_SIX_AMOUNT: int = 2
const ROW_SEVEN_AMOUNT: int = 3

const ROW_PATTERN: Array[int] = [
	ROW_ONE_AMOUNT,
	ROW_TWO_AMOUNT,
	ROW_THREE_AMOUNT,
	ROW_FOUR_AMOUNT,
	ROW_FIVE_AMOUNT,
	ROW_SIX_AMOUNT,
	ROW_SEVEN_AMOUNT
]

const HAND_SIZE: int = 3
const MAX_DAMAGE: int = 7
const CARDS_PER_DRAW: int = 3
const CARDS_TO_DEFEAT_MONSTER: int = 3
const POWER_ATTACK_CARD_COUNT: int = 2
const MAX_ATTACK_CARD_VALUE: int = CardUtils.JOKER_VALUE

const FIRST_ATTACK_CARD_INDEX: int = 0
const SECOND_ATTACK_CARD_INDEX: int = 1
const TRIGGER_CARD_INDEX: int = 2

const NEXT_ROW_OFFSET: int = 1
const ROW_WIDTH_DELTA: int = 1
const LEFT_BLOCKER_OFFSET: int = -1
const SAME_COLUMN_OFFSET: int = 0
const RIGHT_BLOCKER_OFFSET: int = 1

const EMPTY_COUNT: int = 0
const ONE_CARD_COUNT: int = 1

const SLOT_KEY_CARD: String = "card"
const SLOT_KEY_ATTACK_CARDS: String = "attack_cards"

const MSG_GAME_FINISHED: String = "The game is already finished."
const MSG_DAMAGE_LOSE: String = "No hearts left. You lose."
const MSG_DECK_EMPTY_LOSE: String = "The Power Deck is empty. You lose."
const MSG_DRAW_LAST_CARDS: String = "You drew the last cards from the Power Deck."
const MSG_DRAW_THREE: String = "Drew 3 cards."
const MSG_INVALID_HAND_CARD: String = "Invalid hand card."
const MSG_DUPLICATE_HAND_CARD: String = "The same card cannot be selected twice."
const MSG_INVALID_ROW: String = "Invalid row."
const MSG_INVALID_POSITION: String = "Invalid position."
const MSG_SLOT_EMPTY: String = "That slot is already empty."
const MSG_SLOT_HIDDEN: String = "That card is still covered."
const MSG_SELECT_HAND_CARD: String = "Select at least one hand card first."
const MSG_CANNOT_ATTACK_LOOT: String = "That card is loot. Pick it up instead."
const MSG_NOT_LOOT: String = "That card is not loot."
const MSG_HAND_FULL: String = "Your hand is full."
const MSG_PICKED_JOKER: String = "Picked up Joker loot."
const MSG_TOO_MANY_ATTACK_CARDS: String = "That monster can only have 3 attack cards."
const MSG_TRIGGER_SUIT_ERROR: String = "Trigger card must match the monster suit."
const MSG_MONSTER_DEFEATED_FORMAT: String = "Defeated %s."
const MSG_PLACED_CARDS_FORMAT: String = "Placed %d card(s) on %s. Attack: %d/3."
const MSG_LOW_POWER_FORMAT: String = "Attack power is too low. Need %d, got %d."
const MSG_WIN_FORMAT: String = "You cleared the dungeon! Score: %d."
const MSG_IMPOSSIBLE_FIRST_ATTACK_CARD_FORMAT: String = "%s cannot start an attack against %s. Maximum possible attack would be %d, but it needs %d."

var dungeon_deck: Array[Dictionary] = []
var power_deck: Array[Dictionary] = []
var board_state: Array[Array] = []

var hand: Array[Dictionary] = []
var damage_bar: Array[Dictionary] = []
var clear_pile: Array[Dictionary] = []

var game_finished: bool = false
var player_won: bool = false

var selected_layout_id: String = LayoutConfig.DEFAULT_LAYOUT_ID
var row_pattern: Array[int] = LayoutConfig.get_rows(LayoutConfig.DEFAULT_LAYOUT_ID)
var jokers_in_dungeon: bool = LayoutConfig.uses_jokers_in_dungeon(LayoutConfig.DEFAULT_LAYOUT_ID)


func new_game(layout_id: String = NO_LAYOUT_ID) -> void:
	if layout_id != NO_LAYOUT_ID:
		configure_layout(layout_id)

	game_finished = false
	player_won = false

	dungeon_deck = _create_dungeon_deck()
	dungeon_deck.shuffle()

	power_deck = _create_power_deck()
	power_deck.shuffle()

	board_state.clear()
	hand.clear()
	damage_bar.clear()
	clear_pile.clear()

	_fill_board_with_dungeon_cards()


func configure_layout(layout_id: String) -> void:
	selected_layout_id = layout_id
	row_pattern = LayoutConfig.get_rows(layout_id)
	jokers_in_dungeon = LayoutConfig.uses_jokers_in_dungeon(layout_id)


func draw_hand() -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if hand.size() > EMPTY_COUNT:
		damage_bar.append_array(hand)
		hand.clear()

		if _damage_reached_limit():
			return MSG_DAMAGE_LOSE

	if power_deck.size() == EMPTY_COUNT:
		game_finished = true
		player_won = false
		return MSG_DECK_EMPTY_LOSE

	var draw_count: int = min(CARDS_PER_DRAW, power_deck.size())

	for draw_index in range(draw_count):
		hand.append(power_deck.pop_back())

	if draw_count < CARDS_PER_DRAW:
		return MSG_DRAW_LAST_CARDS

	return MSG_DRAW_THREE


func place_hand_cards_on_slot(hand_indices: Array[int], row: int, col: int) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if hand_indices.is_empty():
		return MSG_SELECT_HAND_CARD

	var position_error: String = _validate_board_position(row, col)

	if position_error != "":
		return position_error

	if not is_slot_uncovered(row, col):
		return MSG_SLOT_HIDDEN

	var hand_error: String = _validate_hand_indices(hand_indices)

	if hand_error != "":
		return hand_error

	var slot: Dictionary = board_state[row][col]
	var card: Dictionary = slot[SLOT_KEY_CARD]

	if card.is_empty():
		return MSG_SLOT_EMPTY

	if CardUtils.is_loot(card):
		return MSG_CANNOT_ATTACK_LOOT

	var current_attack_cards: Array = slot[SLOT_KEY_ATTACK_CARDS]

	if current_attack_cards.size() + hand_indices.size() > CARDS_TO_DEFEAT_MONSTER:
		return MSG_TOO_MANY_ATTACK_CARDS

	var cards_to_place: Array[Dictionary] = []

	for hand_index in hand_indices:
		cards_to_place.append(hand[hand_index])

	var new_attack_cards: Array = current_attack_cards.duplicate()

	for card_to_place in cards_to_place:
		new_attack_cards.append(card_to_place)

	var attack_error: String = _get_attack_error(card, new_attack_cards)

	if attack_error != "":
		return attack_error

	if new_attack_cards.size() == CARDS_TO_DEFEAT_MONSTER:
		return _defeat_monster(row, col, new_attack_cards, hand_indices)

	slot[SLOT_KEY_ATTACK_CARDS] = new_attack_cards
	board_state[row][col] = slot

	_remove_hand_cards(hand_indices)

	return MSG_PLACED_CARDS_FORMAT % [
		hand_indices.size(),
		CardUtils.short_text(card),
		new_attack_cards.size()
	]


func take_loot(row: int, col: int) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	var position_error: String = _validate_board_position(row, col)

	if position_error != "":
		return position_error

	if not is_slot_uncovered(row, col):
		return MSG_SLOT_HIDDEN

	var slot: Dictionary = board_state[row][col]
	var card: Dictionary = slot[SLOT_KEY_CARD]

	if card.is_empty():
		return MSG_SLOT_EMPTY

	if not CardUtils.is_loot(card):
		return MSG_NOT_LOOT

	if hand.size() >= HAND_SIZE:
		return MSG_HAND_FULL

	hand.append(CardUtils.make_joker_power_card())

	slot[SLOT_KEY_CARD] = {}
	slot[SLOT_KEY_ATTACK_CARDS] = []
	board_state[row][col] = slot

	if _check_win():
		return MSG_WIN_FORMAT % power_deck.size()

	return MSG_PICKED_JOKER


func get_slot(row: int, col: int) -> Dictionary:
	return board_state[row][col]


func get_slot_card(row: int, col: int) -> Dictionary:
	return board_state[row][col][SLOT_KEY_CARD]


func is_slot_empty(row: int, col: int) -> bool:
	return get_slot_card(row, col).is_empty()


func is_slot_loot(row: int, col: int) -> bool:
	return CardUtils.is_loot(get_slot_card(row, col))


func has_accessible_loot() -> bool:
	for row_index in range(board_state.size()):
		for col_index in range(board_state[row_index].size()):
			if is_slot_loot(row_index, col_index) and is_slot_uncovered(row_index, col_index):
				return true

	return false


func is_slot_uncovered(row: int, col: int) -> bool:
	var position_error: String = _validate_board_position(row, col)

	if position_error != "":
		return false

	var blocking_positions: Array[Vector2i] = _get_blocking_positions(row, col)

	for position in blocking_positions:
		var blocking_slot: Dictionary = board_state[position.x][position.y]
		var blocking_card: Dictionary = blocking_slot[SLOT_KEY_CARD]

		if not blocking_card.is_empty():
			return false

	return true


func all_monsters_defeated() -> bool:
	for row in board_state:
		for slot_variant in row:
			var slot: Dictionary = slot_variant
			var card: Dictionary = slot[SLOT_KEY_CARD]

			if CardUtils.is_monster(card):
				return false

	return true


func _create_dungeon_deck() -> Array[Dictionary]:
	var cards: Array[Dictionary] = []

	for suit in CardUtils.SUITS:
		for rank in CardUtils.MONSTER_RANKS:
			cards.append(CardUtils.make_card(rank, suit, CardUtils.CARD_TYPE_MONSTER))

	if jokers_in_dungeon:
		for joker_index in range(JOKER_COUNT):
			cards.append(CardUtils.make_joker_loot_card())

	return cards


func _create_power_deck() -> Array[Dictionary]:
	var cards: Array[Dictionary] = []

	for suit in CardUtils.SUITS:
		for rank in CardUtils.POWER_RANKS:
			cards.append(CardUtils.make_card(rank, suit, CardUtils.CARD_TYPE_POWER))

	if not jokers_in_dungeon:
		for joker_index in range(JOKER_COUNT):
			cards.append(CardUtils.make_joker_power_card())

	return cards


func _fill_board_with_dungeon_cards() -> void:
	for row_index in range(row_pattern.size()):
		var amount: int = row_pattern[row_index]
		var row_slots: Array[Dictionary] = []

		for col_index in range(amount):
			var card: Dictionary = {}

			if dungeon_deck.size() > EMPTY_COUNT:
				card = dungeon_deck.pop_back()

			row_slots.append({
				SLOT_KEY_CARD: card,
				SLOT_KEY_ATTACK_CARDS: []
			})

		board_state.append(row_slots)


func _get_attack_error(monster: Dictionary, attack_cards: Array) -> String:
	if attack_cards.size() == ONE_CARD_COUNT:
		return _get_first_attack_card_error(monster, attack_cards[FIRST_ATTACK_CARD_INDEX])

	if attack_cards.size() < POWER_ATTACK_CARD_COUNT:
		return ""

	var first_card: Dictionary = attack_cards[FIRST_ATTACK_CARD_INDEX]
	var second_card: Dictionary = attack_cards[SECOND_ATTACK_CARD_INDEX]

	var attack_power: int = CardUtils.power_value(first_card) + CardUtils.power_value(second_card)
	var required_power: int = CardUtils.monster_power(monster)

	if attack_power < required_power:
		return MSG_LOW_POWER_FORMAT % [required_power, attack_power]

	if attack_cards.size() < CARDS_TO_DEFEAT_MONSTER:
		return ""

	var trigger_card: Dictionary = attack_cards[TRIGGER_CARD_INDEX]

	if not CardUtils.trigger_matches(trigger_card, monster):
		return MSG_TRIGGER_SUIT_ERROR

	return ""


func _get_first_attack_card_error(monster: Dictionary, first_card: Dictionary) -> String:
	var first_card_value: int = CardUtils.power_value(first_card)
	var maximum_possible_attack: int = first_card_value + MAX_ATTACK_CARD_VALUE
	var required_power: int = CardUtils.monster_power(monster)

	if maximum_possible_attack < required_power:
		return MSG_IMPOSSIBLE_FIRST_ATTACK_CARD_FORMAT % [
			CardUtils.short_text(first_card),
			CardUtils.short_text(monster),
			maximum_possible_attack,
			required_power
		]

	return ""


func _defeat_monster(row: int, col: int, attack_cards: Array, hand_indices: Array[int]) -> String:
	var slot: Dictionary = board_state[row][col]
	var monster: Dictionary = slot[SLOT_KEY_CARD]

	clear_pile.append(monster)

	for attack_card in attack_cards:
		clear_pile.append(attack_card)

	slot[SLOT_KEY_CARD] = {}
	slot[SLOT_KEY_ATTACK_CARDS] = []
	board_state[row][col] = slot

	_remove_hand_cards(hand_indices)

	if _check_win():
		return MSG_WIN_FORMAT % power_deck.size()

	return MSG_MONSTER_DEFEATED_FORMAT % CardUtils.short_text(monster)


func _check_win() -> bool:
	if all_monsters_defeated():
		game_finished = true
		player_won = true
		return true

	return false


func _remove_hand_cards(hand_indices: Array[int]) -> void:
	var indices_to_remove: Array[int] = hand_indices.duplicate()
	indices_to_remove.sort()
	indices_to_remove.reverse()

	for hand_index in indices_to_remove:
		hand.remove_at(hand_index)


func _validate_hand_indices(hand_indices: Array[int]) -> String:
	var seen_indices: Array[int] = []

	for hand_index in hand_indices:
		if hand_index < EMPTY_COUNT or hand_index >= hand.size():
			return MSG_INVALID_HAND_CARD

		if seen_indices.has(hand_index):
			return MSG_DUPLICATE_HAND_CARD

		seen_indices.append(hand_index)

	return ""


func _validate_board_position(row: int, col: int) -> String:
	if row < EMPTY_COUNT or row >= board_state.size():
		return MSG_INVALID_ROW

	if col < EMPTY_COUNT or col >= board_state[row].size():
		return MSG_INVALID_POSITION

	return ""


func _damage_reached_limit() -> bool:
	if damage_bar.size() >= MAX_DAMAGE:
		game_finished = true
		player_won = false
		return true

	return false


func _get_blocking_positions(row: int, col: int) -> Array[Vector2i]:
	var positions: Array[Vector2i] = []
	var lower_row: int = row + NEXT_ROW_OFFSET

	if lower_row >= board_state.size():
		return positions

	var current_row_count: int = board_state[row].size()
	var lower_row_count: int = board_state[lower_row].size()

	if lower_row_count == current_row_count + ROW_WIDTH_DELTA:
		_append_blocker_if_exists(positions, lower_row, col + SAME_COLUMN_OFFSET)
		_append_blocker_if_exists(positions, lower_row, col + RIGHT_BLOCKER_OFFSET)
	elif lower_row_count == current_row_count - ROW_WIDTH_DELTA:
		_append_blocker_if_exists(positions, lower_row, col + LEFT_BLOCKER_OFFSET)
		_append_blocker_if_exists(positions, lower_row, col + SAME_COLUMN_OFFSET)
	else:
		_append_blocker_if_exists(positions, lower_row, col + SAME_COLUMN_OFFSET)

	return positions


func _append_blocker_if_exists(positions: Array[Vector2i], row: int, col: int) -> void:
	if row < EMPTY_COUNT or row >= board_state.size():
		return

	if col < EMPTY_COUNT or col >= board_state[row].size():
		return

	positions.append(Vector2i(row, col))
