extends RefCounted
class_name CardUtils

const CARD_TYPE_MONSTER: String = "monster"
const CARD_TYPE_POWER: String = "power"
const CARD_TYPE_LOOT: String = "loot"

const SUIT_HEARTS: String = "♥"
const SUIT_DIAMONDS: String = "♦"
const SUIT_CLUBS: String = "♣"
const SUIT_SPADES: String = "♠"
const SUIT_ANY: String = "ANY"

const SUITS: Array[String] = [SUIT_HEARTS, SUIT_DIAMONDS, SUIT_CLUBS, SUIT_SPADES]

const RANK_ACE: String = "A"
const RANK_TWO: String = "2"
const RANK_THREE: String = "3"
const RANK_FOUR: String = "4"
const RANK_FIVE: String = "5"
const RANK_SIX: String = "6"
const RANK_SEVEN: String = "7"
const RANK_EIGHT: String = "8"
const RANK_NINE: String = "9"
const RANK_TEN: String = "10"
const RANK_JACK: String = "J"
const RANK_QUEEN: String = "Q"
const RANK_KING: String = "K"
const RANK_JOKER: String = "Joker"

const POWER_RANKS: Array[String] = [
	RANK_ACE,
	RANK_TWO,
	RANK_THREE,
	RANK_FOUR,
	RANK_FIVE,
	RANK_SIX,
	RANK_SEVEN,
	RANK_EIGHT,
	RANK_NINE,
	RANK_TEN
]

const MONSTER_RANKS: Array[String] = [
	RANK_JACK,
	RANK_QUEEN,
	RANK_KING
]

const ACE_VALUE: int = 1
const BOOMER_ACE_VALUE: int = 11
const JOKER_VALUE: int = 10
const JACK_POWER: int = 11
const QUEEN_POWER: int = 12
const KING_POWER: int = 13
const INVALID_VALUE: int = 0
const DOUBLE_ATTACK_MULTIPLIER: int = 2

const CARD_KEY_RANK: String = "rank"
const CARD_KEY_SUIT: String = "suit"
const CARD_KEY_TYPE: String = "type"
const CARD_KEY_DOUBLED_ATTACK: String = "doubled_attack"


static func make_card(rank: String, suit: String, card_type: String) -> Dictionary:
	return {
		CARD_KEY_RANK: rank,
		CARD_KEY_SUIT: suit,
		CARD_KEY_TYPE: card_type
	}


static func make_joker_loot_card() -> Dictionary:
	return make_card(RANK_JOKER, SUIT_ANY, CARD_TYPE_LOOT)


static func make_joker_power_card() -> Dictionary:
	return make_card(RANK_JOKER, SUIT_ANY, CARD_TYPE_POWER)


static func is_monster(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_TYPE] == CARD_TYPE_MONSTER


static func is_power(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_TYPE] == CARD_TYPE_POWER


static func is_loot(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_TYPE] == CARD_TYPE_LOOT


static func is_joker(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_RANK] == RANK_JOKER


static func is_ace(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_RANK] == RANK_ACE


static func is_king(card: Dictionary) -> bool:
	return not card.is_empty() and card[CARD_KEY_RANK] == RANK_KING


static func power_value(card: Dictionary) -> int:
	return power_value_with_variations(card, false)


static func power_value_with_variations(card: Dictionary, boomer_ace_enabled: bool) -> int:
	var rank: String = card[CARD_KEY_RANK]
	var value: int = INVALID_VALUE

	if rank == RANK_ACE:
		if boomer_ace_enabled:
			value = BOOMER_ACE_VALUE
		else:
			value = ACE_VALUE
	elif rank == RANK_JOKER:
		value = JOKER_VALUE
	else:
		value = int(rank)

	if card.has(CARD_KEY_DOUBLED_ATTACK) and card[CARD_KEY_DOUBLED_ATTACK]:
		value *= DOUBLE_ATTACK_MULTIPLIER

	return value


static func monster_power(monster: Dictionary) -> int:
	var rank: String = monster[CARD_KEY_RANK]

	match rank:
		RANK_JACK:
			return JACK_POWER
		RANK_QUEEN:
			return QUEEN_POWER
		RANK_KING:
			return KING_POWER

	return INVALID_VALUE


static func trigger_matches(trigger_card: Dictionary, monster: Dictionary) -> bool:
	if is_joker(trigger_card):
		return true

	return trigger_card[CARD_KEY_SUIT] == monster[CARD_KEY_SUIT]


static func card_without_temporary_flags(card: Dictionary) -> Dictionary:
	var clean_card: Dictionary = card.duplicate()
	clean_card.erase(CARD_KEY_DOUBLED_ATTACK)
	return clean_card


static func card_text(card: Dictionary) -> String:
	if card.is_empty():
		return ""

	var text: String = ""

	if is_joker(card):
		text = RANK_JOKER
	else:
		text = "%s%s" % [card[CARD_KEY_RANK], card[CARD_KEY_SUIT]]

	if card.has(CARD_KEY_DOUBLED_ATTACK) and card[CARD_KEY_DOUBLED_ATTACK]:
		text += " x2"

	return text


static func short_text(card: Dictionary) -> String:
	if card.is_empty():
		return ""

	if is_joker(card):
		return RANK_JOKER

	return "%s%s" % [card[CARD_KEY_RANK], card[CARD_KEY_SUIT]]
