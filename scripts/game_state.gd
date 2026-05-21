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
const POWER_RESERVE_INITIAL_DRAW: int = 5
const POWER_RESERVE_SIZE: int = 2
const MAX_VISIBLE_HAND_CARDS: int = 5
const CARDS_TO_DEFEAT_MONSTER: int = 3
const POWER_ATTACK_CARD_COUNT: int = 2

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
const NO_CARD_INDEX: int = -1

const SLOT_KEY_CARD: String = "card"
const SLOT_KEY_ATTACK_CARDS: String = "attack_cards"

const CARD_SOURCE_HAND: String = "hand"
const CARD_SOURCE_RESERVE: String = "reserve"
const PLAY_REF_KEY_SOURCE: String = "source"
const PLAY_REF_KEY_INDEX: String = "index"

const MSG_GAME_FINISHED: String = "The game is already finished."
const MSG_DAMAGE_LOSE: String = "No hearts left. You lose."
const MSG_DECK_EMPTY_LOSE: String = "The Power Deck is empty. You lose."
const MSG_DRAW_LAST_CARDS: String = "You drew the last cards from the Power Deck."
const MSG_DRAW_THREE: String = "Drew 3 cards."
const MSG_INVALID_HAND_CARD: String = "Invalid hand card."
const MSG_INVALID_RESERVE_CARD: String = "Invalid reserve card."
const MSG_INVALID_PLAY_CARD: String = "Invalid selected card."
const MSG_DUPLICATE_HAND_CARD: String = "The same card cannot be selected twice."
const MSG_DUPLICATE_PLAY_CARD: String = "The same card cannot be selected twice."
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
const MSG_MONSTER_DEFEATED_BOOMER_FORMAT: String = "Defeated %s. The Ace trigger returned to your hand."
const MSG_PLACED_CARDS_FORMAT: String = "Placed %d card(s) on %s. Attack: %d/3."
const MSG_LOW_POWER_FORMAT: String = "Attack power is too low. Need %d, got %d."
const MSG_WIN_FORMAT: String = "You cleared the dungeon! Score: %d."
const MSG_IMPOSSIBLE_FIRST_ATTACK_CARD_FORMAT: String = "%s cannot start an attack against %s. Maximum possible attack would be %d, but it needs %d."

const MSG_POWER_RESERVE_CHOOSE: String = "Choose 2 cards for your Power Reserve."
const MSG_POWER_RESERVE_READY: String = "Power Reserve ready. Play cards or press End Turn."
const MSG_POWER_RESERVE_NEEDS_TWO: String = "Choose exactly 2 hand cards for your Power Reserve."
const MSG_POWER_RESERVE_SETUP_REQUIRED: String = "Choose your Power Reserve before playing."

const MSG_NO_SPECIAL_ABILITIES: String = "Special Abilities is not active."
const MSG_INVALID_ABILITY: String = "Invalid ability."
const MSG_HEART_SELECT_ONE_HAND: String = "K♥ needs exactly 1 selected hand card."
const MSG_HEART_USED_FORMAT: String = "K♥ used. Put %s at the bottom of the Power Deck."
const MSG_DIAMOND_EMPTY_DECK: String = "The Power Deck is empty. K♦ cannot be used."
const MSG_DIAMOND_REVEALED_FORMAT: String = "K♦ revealed bottom card: %s. Choose Top or Leave."
const MSG_DIAMOND_MOVED_FORMAT: String = "K♦ used. Moved %s to the top of the Power Deck."
const MSG_DIAMOND_LEFT_FORMAT: String = "K♦ used. Left %s at the bottom of the Power Deck."
const MSG_DIAMOND_CHOICE_REQUIRED: String = "Choose Top or Leave for K♦ first."
const MSG_SPADE_USED: String = "K♠ used. The next attack card you place will count double."
const MSG_CLUB_EMPTY_DECK: String = "The Power Deck is empty. K♣ cannot be used."
const MSG_CLUB_USED_FORMAT: String = "K♣ used. Drew %s from the Power Deck."

var dungeon_deck: Array[Dictionary] = []
var power_deck: Array[Dictionary] = []
var board_state: Array[Array] = []

var hand: Array[Dictionary] = []
var damage_bar: Array[Dictionary] = []
var clear_pile: Array[Dictionary] = []
var power_reserve: Array[Dictionary] = []
var king_inventory: Array[Dictionary] = []

var game_finished: bool = false
var player_won: bool = false

var selected_variation_ids: Array[String] = []
var selected_layout_id: String = LayoutConfig.DEFAULT_LAYOUT_ID
var row_pattern: Array[int] = LayoutConfig.get_rows(LayoutConfig.DEFAULT_LAYOUT_ID)
var jokers_in_dungeon: bool = LayoutConfig.uses_jokers_in_dungeon(LayoutConfig.DEFAULT_LAYOUT_ID)

var power_reserve_initialized: bool = false
var power_reserve_setup_pending: bool = false
var double_next_attack_card: bool = false
var diamond_ability_pending: bool = false
var diamond_ability_index: int = NO_CARD_INDEX
var diamond_revealed_card: Dictionary = {}


func new_game(layout_id: String = NO_LAYOUT_ID, variation_ids: Array[String] = []) -> void:
	if layout_id != NO_LAYOUT_ID:
		configure_layout(layout_id)
	
	configure_variations(variation_ids)

	game_finished = false
	player_won = false
	power_reserve_initialized = false
	power_reserve_setup_pending = false
	double_next_attack_card = false
	diamond_ability_pending = false
	diamond_ability_index = NO_CARD_INDEX
	diamond_revealed_card = {}

	dungeon_deck = _create_dungeon_deck()
	dungeon_deck.shuffle()

	power_deck = _create_power_deck()
	power_deck.shuffle()

	board_state.clear()
	hand.clear()
	damage_bar.clear()
	clear_pile.clear()
	power_reserve.clear()
	king_inventory.clear()

	_fill_board_with_dungeon_cards()


func configure_layout(layout_id: String) -> void:
	selected_layout_id = layout_id
	row_pattern = LayoutConfig.get_rows(layout_id)
	jokers_in_dungeon = LayoutConfig.uses_jokers_in_dungeon(layout_id)


func configure_variations(variation_ids: Array[String]) -> void:
	selected_variation_ids = variation_ids.duplicate()


func has_variation(variation_id: String) -> bool:
	return selected_variation_ids.has(variation_id)


func is_boomer_ace_active() -> bool:
	return has_variation(VariationConfig.VARIATION_ID_BOOMER_ACE)


func is_power_reserve_active() -> bool:
	return has_variation(VariationConfig.VARIATION_ID_POWER_RESERVE)


func is_special_abilities_active() -> bool:
	return has_variation(VariationConfig.VARIATION_ID_SPECIAL_ABILITIES)


func get_visible_hand_button_count() -> int:
	return max(HAND_SIZE, min(hand.size(), MAX_VISIBLE_HAND_CARDS))


func get_attack_card_value(card: Dictionary) -> int:
	return CardUtils.power_value_with_variations(card, is_boomer_ace_active())


func make_play_card_ref(source: String, index: int) -> Dictionary:
	return {
		PLAY_REF_KEY_SOURCE: source,
		PLAY_REF_KEY_INDEX: index
	}


func draw_hand() -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if power_reserve_setup_pending:
		return MSG_POWER_RESERVE_SETUP_REQUIRED

	if diamond_ability_pending:
		return MSG_DIAMOND_CHOICE_REQUIRED

	if hand.size() > EMPTY_COUNT:
		damage_bar.append_array(hand)
		hand.clear()

		if _damage_reached_limit():
			return MSG_DAMAGE_LOSE

	if power_deck.size() == EMPTY_COUNT:
		game_finished = true
		player_won = false
		return MSG_DECK_EMPTY_LOSE

	var cards_to_draw: int = CARDS_PER_DRAW

	if _needs_power_reserve_initial_draw():
		cards_to_draw = POWER_RESERVE_INITIAL_DRAW
		power_reserve_initialized = true
		power_reserve_setup_pending = true

	var draw_count: int = min(cards_to_draw, power_deck.size())

	for draw_index in range(draw_count):
		hand.append(power_deck.pop_back())

	if power_reserve_setup_pending:
		return MSG_POWER_RESERVE_CHOOSE

	if draw_count < cards_to_draw:
		return MSG_DRAW_LAST_CARDS

	return MSG_DRAW_THREE


func set_power_reserve_from_hand(hand_indices: Array[int]) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if not power_reserve_setup_pending:
		return MSG_POWER_RESERVE_SETUP_REQUIRED

	if hand_indices.size() != POWER_RESERVE_SIZE:
		return MSG_POWER_RESERVE_NEEDS_TWO

	var hand_error: String = _validate_hand_indices(hand_indices)

	if hand_error != "":
		return hand_error

	for hand_index in hand_indices:
		power_reserve.append(hand[hand_index])

	_remove_hand_cards(hand_indices)
	power_reserve_setup_pending = false

	return MSG_POWER_RESERVE_READY


func place_hand_cards_on_slot(hand_indices: Array[int], row: int, col: int) -> String:
	var card_refs: Array[Dictionary] = []

	for hand_index in hand_indices:
		card_refs.append(make_play_card_ref(CARD_SOURCE_HAND, hand_index))

	return place_play_cards_on_slot(card_refs, row, col)


func place_play_cards_on_slot(card_refs: Array[Dictionary], row: int, col: int) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if card_refs.is_empty():
		return MSG_SELECT_HAND_CARD

	if power_reserve_setup_pending:
		return MSG_POWER_RESERVE_SETUP_REQUIRED

	if diamond_ability_pending:
		return MSG_DIAMOND_CHOICE_REQUIRED

	var position_error: String = _validate_board_position(row, col)

	if position_error != "":
		return position_error

	if not is_slot_uncovered(row, col):
		return MSG_SLOT_HIDDEN

	var play_error: String = _validate_play_card_refs(card_refs)

	if play_error != "":
		return play_error

	var slot: Dictionary = board_state[row][col]
	var card: Dictionary = slot[SLOT_KEY_CARD]

	if card.is_empty():
		return MSG_SLOT_EMPTY

	if CardUtils.is_loot(card):
		return MSG_CANNOT_ATTACK_LOOT

	var current_attack_cards: Array = slot[SLOT_KEY_ATTACK_CARDS]

	if current_attack_cards.size() + card_refs.size() > CARDS_TO_DEFEAT_MONSTER:
		return MSG_TOO_MANY_ATTACK_CARDS

	var cards_to_place: Array[Dictionary] = []
	var double_applied: bool = false

	for card_ref in card_refs:
		var card_to_place: Dictionary = _get_play_card(card_ref).duplicate()
		var future_attack_index: int = current_attack_cards.size() + cards_to_place.size()

		if double_next_attack_card and future_attack_index < POWER_ATTACK_CARD_COUNT:
			card_to_place[CardUtils.CARD_KEY_DOUBLED_ATTACK] = true
			double_applied = true

		cards_to_place.append(card_to_place)

	var new_attack_cards: Array = current_attack_cards.duplicate()

	for card_to_place in cards_to_place:
		new_attack_cards.append(card_to_place)

	var attack_error: String = _get_attack_error(card, new_attack_cards)

	if attack_error != "":
		return attack_error

	if double_applied:
		double_next_attack_card = false

	if new_attack_cards.size() == CARDS_TO_DEFEAT_MONSTER:
		return _defeat_monster(row, col, new_attack_cards, card_refs)

	slot[SLOT_KEY_ATTACK_CARDS] = new_attack_cards
	board_state[row][col] = slot

	_remove_play_cards(card_refs)

	return MSG_PLACED_CARDS_FORMAT % [
		card_refs.size(),
		CardUtils.short_text(card),
		new_attack_cards.size()
	]


func take_loot(row: int, col: int) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if power_reserve_setup_pending:
		return MSG_POWER_RESERVE_SETUP_REQUIRED

	if diamond_ability_pending:
		return MSG_DIAMOND_CHOICE_REQUIRED

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
		return MSG_WIN_FORMAT % get_score()

	return MSG_PICKED_JOKER


func use_king_ability(ability_index: int, selected_card_refs: Array[Dictionary]) -> String:
	if game_finished:
		return MSG_GAME_FINISHED

	if not is_special_abilities_active():
		return MSG_NO_SPECIAL_ABILITIES

	if diamond_ability_pending:
		return MSG_DIAMOND_CHOICE_REQUIRED

	if ability_index < EMPTY_COUNT or ability_index >= king_inventory.size():
		return MSG_INVALID_ABILITY

	var king: Dictionary = king_inventory[ability_index]
	var suit: String = king[CardUtils.CARD_KEY_SUIT]

	match suit:
		CardUtils.SUIT_HEARTS:
			return _use_heart_king_ability(ability_index, selected_card_refs)
		CardUtils.SUIT_DIAMONDS:
			return _use_diamond_king_ability(ability_index)
		CardUtils.SUIT_SPADES:
			return _use_spade_king_ability(ability_index)
		CardUtils.SUIT_CLUBS:
			return _use_club_king_ability(ability_index)

	return MSG_INVALID_ABILITY


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


func get_score() -> int:
	var score: int = power_deck.size()

	if player_won and is_power_reserve_active():
		score += power_reserve.size()

	return score


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

	var attack_power: int = get_attack_card_value(first_card) + get_attack_card_value(second_card)
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
	var first_card_value: int = get_attack_card_value(first_card)
	var maximum_possible_attack: int = first_card_value + _maximum_attack_card_value()
	var required_power: int = CardUtils.monster_power(monster)

	if maximum_possible_attack < required_power:
		return MSG_IMPOSSIBLE_FIRST_ATTACK_CARD_FORMAT % [
			CardUtils.short_text(first_card),
			CardUtils.short_text(monster),
			maximum_possible_attack,
			required_power
		]

	return ""


func _defeat_monster(row: int, col: int, attack_cards: Array, card_refs: Array[Dictionary]) -> String:
	var slot: Dictionary = board_state[row][col]
	var monster: Dictionary = slot[SLOT_KEY_CARD]
	var boomer_return_index: int = _get_boomer_ace_return_index(attack_cards)

	if is_special_abilities_active() and CardUtils.is_king(monster):
		king_inventory.append(monster)
	else:
		clear_pile.append(monster)

	for attack_card_index in range(attack_cards.size()):
		if attack_card_index == boomer_return_index:
			continue

		var attack_card: Dictionary = attack_cards[attack_card_index]
		clear_pile.append(CardUtils.card_without_temporary_flags(attack_card))

	slot[SLOT_KEY_CARD] = {}
	slot[SLOT_KEY_ATTACK_CARDS] = []
	board_state[row][col] = slot

	_remove_play_cards(card_refs)

	if boomer_return_index != NO_CARD_INDEX:
		hand.append(CardUtils.card_without_temporary_flags(attack_cards[boomer_return_index]))

	if _check_win():
		return MSG_WIN_FORMAT % get_score()

	if boomer_return_index != NO_CARD_INDEX:
		return MSG_MONSTER_DEFEATED_BOOMER_FORMAT % CardUtils.short_text(monster)

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


func _remove_play_cards(card_refs: Array[Dictionary]) -> void:
	var hand_indices: Array[int] = []
	var reserve_indices: Array[int] = []

	for card_ref in card_refs:
		var source: String = card_ref[PLAY_REF_KEY_SOURCE]
		var index: int = card_ref[PLAY_REF_KEY_INDEX]

		if source == CARD_SOURCE_HAND:
			hand_indices.append(index)
		elif source == CARD_SOURCE_RESERVE:
			reserve_indices.append(index)

	_remove_hand_cards(hand_indices)
	_remove_reserve_cards(reserve_indices)


func _remove_reserve_cards(reserve_indices: Array[int]) -> void:
	var indices_to_remove: Array[int] = reserve_indices.duplicate()
	indices_to_remove.sort()
	indices_to_remove.reverse()

	for reserve_index in indices_to_remove:
		power_reserve.remove_at(reserve_index)


func _validate_hand_indices(hand_indices: Array[int]) -> String:
	var seen_indices: Array[int] = []

	for hand_index in hand_indices:
		if hand_index < EMPTY_COUNT or hand_index >= hand.size():
			return MSG_INVALID_HAND_CARD

		if seen_indices.has(hand_index):
			return MSG_DUPLICATE_HAND_CARD

		seen_indices.append(hand_index)

	return ""


func _validate_play_card_refs(card_refs: Array[Dictionary]) -> String:
	var seen_refs: Array[String] = []

	for card_ref in card_refs:
		if not card_ref.has(PLAY_REF_KEY_SOURCE) or not card_ref.has(PLAY_REF_KEY_INDEX):
			return MSG_INVALID_PLAY_CARD

		var source: String = card_ref[PLAY_REF_KEY_SOURCE]
		var index: int = card_ref[PLAY_REF_KEY_INDEX]
		var key: String = "%s:%d" % [source, index]

		if seen_refs.has(key):
			return MSG_DUPLICATE_PLAY_CARD

		seen_refs.append(key)

		if source == CARD_SOURCE_HAND:
			if index < EMPTY_COUNT or index >= hand.size():
				return MSG_INVALID_HAND_CARD
		elif source == CARD_SOURCE_RESERVE:
			if not is_power_reserve_active():
				return MSG_INVALID_RESERVE_CARD

			if index < EMPTY_COUNT or index >= power_reserve.size():
				return MSG_INVALID_RESERVE_CARD
		else:
			return MSG_INVALID_PLAY_CARD

	return ""


func _get_play_card(card_ref: Dictionary) -> Dictionary:
	var source: String = card_ref[PLAY_REF_KEY_SOURCE]
	var index: int = card_ref[PLAY_REF_KEY_INDEX]

	if source == CARD_SOURCE_RESERVE:
		return power_reserve[index]

	return hand[index]


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


func _needs_power_reserve_initial_draw() -> bool:
	return is_power_reserve_active() and not power_reserve_initialized


func _maximum_attack_card_value() -> int:
	if is_boomer_ace_active():
		return CardUtils.BOOMER_ACE_VALUE

	return CardUtils.JOKER_VALUE


func _get_boomer_ace_return_index(attack_cards: Array) -> int:
	if not is_boomer_ace_active():
		return NO_CARD_INDEX

	if attack_cards.size() <= TRIGGER_CARD_INDEX:
		return NO_CARD_INDEX

	if CardUtils.is_ace(attack_cards[TRIGGER_CARD_INDEX]):
		return TRIGGER_CARD_INDEX

	return NO_CARD_INDEX


func _consume_king_ability(ability_index: int) -> Dictionary:
	var king: Dictionary = king_inventory[ability_index]
	king_inventory.remove_at(ability_index)
	clear_pile.append(king)
	return king


func _use_heart_king_ability(ability_index: int, selected_card_refs: Array[Dictionary]) -> String:
	if selected_card_refs.size() != ONE_CARD_COUNT:
		return MSG_HEART_SELECT_ONE_HAND

	var card_ref: Dictionary = selected_card_refs[0]

	if card_ref[PLAY_REF_KEY_SOURCE] != CARD_SOURCE_HAND:
		return MSG_HEART_SELECT_ONE_HAND

	var hand_index: int = card_ref[PLAY_REF_KEY_INDEX]

	if hand_index < EMPTY_COUNT or hand_index >= hand.size():
		return MSG_INVALID_HAND_CARD

	var card: Dictionary = hand[hand_index]
	power_deck.push_front(card)
	hand.remove_at(hand_index)
	_consume_king_ability(ability_index)

	return MSG_HEART_USED_FORMAT % CardUtils.short_text(card)


func _use_diamond_king_ability(ability_index: int) -> String:
	if power_deck.size() == EMPTY_COUNT:
		return MSG_DIAMOND_EMPTY_DECK

	diamond_ability_pending = true
	diamond_ability_index = ability_index
	diamond_revealed_card = power_deck[0].duplicate()

	return MSG_DIAMOND_REVEALED_FORMAT % CardUtils.short_text(diamond_revealed_card)


func choose_diamond_king_result(move_to_top: bool) -> String:
	if not diamond_ability_pending:
		return MSG_INVALID_ABILITY

	if power_deck.size() == EMPTY_COUNT:
		diamond_ability_pending = false
		diamond_ability_index = NO_CARD_INDEX
		diamond_revealed_card = {}
		return MSG_DIAMOND_EMPTY_DECK

	var bottom_card: Dictionary = power_deck[0]

	if move_to_top:
		bottom_card = power_deck.pop_front()
		power_deck.append(bottom_card)
		_consume_king_ability(diamond_ability_index)

		diamond_ability_pending = false
		diamond_ability_index = NO_CARD_INDEX
		diamond_revealed_card = {}

		return MSG_DIAMOND_MOVED_FORMAT % CardUtils.short_text(bottom_card)

	_consume_king_ability(diamond_ability_index)

	diamond_ability_pending = false
	diamond_ability_index = NO_CARD_INDEX
	diamond_revealed_card = {}

	return MSG_DIAMOND_LEFT_FORMAT % CardUtils.short_text(bottom_card)


func _use_spade_king_ability(ability_index: int) -> String:
	double_next_attack_card = true
	_consume_king_ability(ability_index)
	return MSG_SPADE_USED


func _use_club_king_ability(ability_index: int) -> String:
	if power_deck.size() == EMPTY_COUNT:
		return MSG_CLUB_EMPTY_DECK

	var drawn_card: Dictionary = power_deck.pop_back()
	hand.append(drawn_card)
	_consume_king_ability(ability_index)

	return MSG_CLUB_USED_FORMAT % CardUtils.short_text(drawn_card)


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
