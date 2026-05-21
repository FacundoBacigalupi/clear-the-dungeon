extends RefCounted
class_name LayoutConfig

const KEY_ID: String = "id"
const KEY_NAME: String = "name"
const KEY_GRAPHIC: String = "graphic"
const KEY_JOKERS_IN_DUNGEON: String = "jokers_in_dungeon"

const LAYOUT_ID_4_4_4: String = "layout_4_4_4"
const LAYOUT_ID_3_3_3_3: String = "layout_3_3_3_3"
const LAYOUT_ID_2_3_3_4: String = "layout_2_3_3_4"
const LAYOUT_ID_2_2_3_2_3: String = "layout_2_2_3_2_3"
const LAYOUT_ID_1_2_3_2_1_2_3: String = "layout_1_2_3_2_1_2_3"

const DEFAULT_LAYOUT_ID: String = LAYOUT_ID_1_2_3_2_1_2_3

const LAYOUT_NAME_4_4_4: String = "Four Columns"
const LAYOUT_NAME_3_3_3_3: String = "Three Columns"
const LAYOUT_NAME_2_3_3_4: String = "Wide Dungeon"
const LAYOUT_NAME_2_2_3_2_3: String = "Cross Dungeon"
const LAYOUT_NAME_1_2_3_2_1_2_3: String = "Extreme Layout"

const GRAPHIC_4_4_4: String = """[X] [X] [X] [X]
[X] [X] [X] [X]
[X] [X] [X] [X]"""

const GRAPHIC_3_3_3_3: String = """[X] [X] [X]
[X] [X] [X]
[X] [X] [X]
[X] [X] [X]"""

const GRAPHIC_2_3_3_4: String = """ [X] [X]
[X] [X] [X]
[X] [X] [X]
[X] [X] [X] [X]"""

const GRAPHIC_2_2_3_2_3: String = """[X] [X]
[X] [X]
[X] [X] [X]
[X] [X]
[X] [X] [X]"""

const GRAPHIC_1_2_3_2_1_2_3: String = """  [X]
  [X] [X]
 [X] [X] [X]
  [X] [X]
  [X]
  [X] [X]
 [X] [X] [X]"""

const ROWS_4_4_4: Array[int] = [4, 4, 4]
const ROWS_3_3_3_3: Array[int] = [3, 3, 3, 3]
const ROWS_2_3_3_4: Array[int] = [2, 3, 3, 4]
const ROWS_2_2_3_2_3: Array[int] = [2, 2, 3, 2, 3]
const ROWS_1_2_3_2_1_2_3: Array[int] = [1, 2, 3, 2, 1, 2, 3]


static func get_layouts() -> Array[Dictionary]:
	return [
		_make_layout(LAYOUT_ID_4_4_4, LAYOUT_NAME_4_4_4, GRAPHIC_4_4_4, false),
		_make_layout(LAYOUT_ID_3_3_3_3, LAYOUT_NAME_3_3_3_3, GRAPHIC_3_3_3_3, false),
		_make_layout(LAYOUT_ID_2_3_3_4, LAYOUT_NAME_2_3_3_4, GRAPHIC_2_3_3_4, false),
		_make_layout(LAYOUT_ID_2_2_3_2_3, LAYOUT_NAME_2_2_3_2_3, GRAPHIC_2_2_3_2_3, false),
		_make_layout(LAYOUT_ID_1_2_3_2_1_2_3, LAYOUT_NAME_1_2_3_2_1_2_3, GRAPHIC_1_2_3_2_1_2_3, true)
	]


static func get_rows(layout_id: String) -> Array[int]:
	match layout_id:
		LAYOUT_ID_4_4_4:
			return ROWS_4_4_4.duplicate()
		LAYOUT_ID_3_3_3_3:
			return ROWS_3_3_3_3.duplicate()
		LAYOUT_ID_2_3_3_4:
			return ROWS_2_3_3_4.duplicate()
		LAYOUT_ID_2_2_3_2_3:
			return ROWS_2_2_3_2_3.duplicate()
		LAYOUT_ID_1_2_3_2_1_2_3:
			return ROWS_1_2_3_2_1_2_3.duplicate()

	return ROWS_1_2_3_2_1_2_3.duplicate()


static func uses_jokers_in_dungeon(layout_id: String) -> bool:
	return layout_id == LAYOUT_ID_1_2_3_2_1_2_3


static func get_layout_name(layout_id: String) -> String:
	match layout_id:
		LAYOUT_ID_4_4_4:
			return LAYOUT_NAME_4_4_4
		LAYOUT_ID_3_3_3_3:
			return LAYOUT_NAME_3_3_3_3
		LAYOUT_ID_2_3_3_4:
			return LAYOUT_NAME_2_3_3_4
		LAYOUT_ID_2_2_3_2_3:
			return LAYOUT_NAME_2_2_3_2_3
		LAYOUT_ID_1_2_3_2_1_2_3:
			return LAYOUT_NAME_1_2_3_2_1_2_3

	return DEFAULT_LAYOUT_ID


static func get_layout_graphic(layout_id: String) -> String:
	match layout_id:
		LAYOUT_ID_4_4_4:
			return GRAPHIC_4_4_4
		LAYOUT_ID_3_3_3_3:
			return GRAPHIC_3_3_3_3
		LAYOUT_ID_2_3_3_4:
			return GRAPHIC_2_3_3_4
		LAYOUT_ID_2_2_3_2_3:
			return GRAPHIC_2_2_3_2_3
		LAYOUT_ID_1_2_3_2_1_2_3:
			return GRAPHIC_1_2_3_2_1_2_3

	return GRAPHIC_1_2_3_2_1_2_3


static func _make_layout(
	layout_id: String,
	layout_name: String,
	layout_graphic: String,
	jokers_in_dungeon: bool
) -> Dictionary:
	return {
		KEY_ID: layout_id,
		KEY_NAME: layout_name,
		KEY_GRAPHIC: layout_graphic,
		KEY_JOKERS_IN_DUNGEON: jokers_in_dungeon
	}
