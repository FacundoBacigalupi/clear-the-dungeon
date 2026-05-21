extends RefCounted
class_name VariationConfig

const KEY_ID: String = "id"
const KEY_NAME: String = "name"
const KEY_DESCRIPTION: String = "description"

const VARIATION_ID_BOOMER_ACE: String = "boomer_ace"
const VARIATION_ID_POWER_RESERVE: String = "power_reserve"
const VARIATION_ID_SPECIAL_ABILITIES: String = "special_abilities"

const VARIATION_NAME_BOOMER_ACE: String = "Boomer-Ace"
const VARIATION_NAME_POWER_RESERVE: String = "Power Reserve"
const VARIATION_NAME_SPECIAL_ABILITIES: String = "Special Abilities"

const VARIATION_DESCRIPTION_BOOMER_ACE: String = "Aces are worth 11. If used as a trigger, they return to your hand."
const VARIATION_DESCRIPTION_POWER_RESERVE: String = "Draw 5 cards at the start and keep 2 as a face-up reserve."
const VARIATION_DESCRIPTION_SPECIAL_ABILITIES: String = "Defeated Kings give one-use special abilities."


static func get_variations() -> Array[Dictionary]:
	return [
		_make_variation(
			VARIATION_ID_BOOMER_ACE,
			VARIATION_NAME_BOOMER_ACE,
			VARIATION_DESCRIPTION_BOOMER_ACE
		),
		_make_variation(
			VARIATION_ID_POWER_RESERVE,
			VARIATION_NAME_POWER_RESERVE,
			VARIATION_DESCRIPTION_POWER_RESERVE
		),
		_make_variation(
			VARIATION_ID_SPECIAL_ABILITIES,
			VARIATION_NAME_SPECIAL_ABILITIES,
			VARIATION_DESCRIPTION_SPECIAL_ABILITIES
		)
	]


static func has_variation(variation_ids: Array[String], variation_id: String) -> bool:
	return variation_ids.has(variation_id)


static func _make_variation(
	variation_id: String,
	variation_name: String,
	variation_description: String
) -> Dictionary:
	return {
		KEY_ID: variation_id,
		KEY_NAME: variation_name,
		KEY_DESCRIPTION: variation_description
	}
