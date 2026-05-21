extends RefCounted
class_name UIStyle

const COLOR_BACKGROUND: String = "#10131A"

const COLOR_PANEL_BACKGROUND: String = "#171C26"
const COLOR_PANEL_BORDER: String = "#313A4A"

const COLOR_WHITE_CARD_BACKGROUND: String = "#F8F8F2"
const COLOR_WHITE_CARD_BORDER: String = "#222222"

const COLOR_HEARTS_TEXT: String = "#C1121F"
const COLOR_DIAMONDS_TEXT: String = "#7FDBFF"
const COLOR_CLUBS_TEXT: String = "#D4AF37"
const COLOR_SPADES_TEXT: String = "#111111"
const COLOR_JOKER_TEXT: String = "#111111"

const COLOR_SELECTED_BORDER: String = "#00A896"
const COLOR_LOOT_BORDER: String = "#D6A700"
const COLOR_MONSTER_BORDER: String = "#222222"
const COLOR_HIDDEN_BACKGROUND: String = "#2B2F3A"
const COLOR_HIDDEN_BORDER: String = "#555B66"
const COLOR_HIDDEN_TEXT: String = "#A0A6B0"

const COLOR_CARD_TEXT: String = "#E8ECF1"

const COLOR_EMPTY_BACKGROUND: String = "#10131A"
const COLOR_EMPTY_BORDER: String = "#10131A"
const COLOR_EMPTY_TEXT: String = "#10131A"

const COLOR_ACTION_BACKGROUND: String = "#20344F"
const COLOR_ACTION_BORDER: String = "#6EA8FE"

const COLOR_RESET_BACKGROUND: String = "#3A2222"
const COLOR_RESET_BORDER: String = "#E06969"

const COLOR_TITLE_TEXT: String = "#F3DFA2"
const COLOR_LABEL_TEXT: String = "#DDE3EA"
const COLOR_MESSAGE_TEXT: String = "#A8DADC"

const COLOR_VARIATION_BACKGROUND: String = "#20344F"
const COLOR_VARIATION_BORDER: String = "#6EA8FE"

const COLOR_VARIATION_SELECTED_BACKGROUND: String = "#2E4D73"
const COLOR_VARIATION_SELECTED_BORDER: String = "#F3DFA2"

const BORDER_WIDTH_NORMAL: int = 2
const BORDER_WIDTH_SELECTED: int = 3
const CORNER_RADIUS: int = 10

const MAIN_TITLE_FONT_SIZE: int = 48
const TITLE_FONT_SIZE: int = 28
const LABEL_FONT_SIZE: int = 16
const CARD_FONT_SIZE: int = 15
const MESSAGE_FONT_SIZE: int = 17
const BUTTON_FONT_SIZE: int = 16
const HAND_CARD_FONT_SIZE: int = 24
const LIFE_FONT_SIZE: int = 30

const THEME_STYLE_NORMAL: String = "normal"
const THEME_STYLE_HOVER: String = "hover"
const THEME_STYLE_PRESSED: String = "pressed"
const THEME_STYLE_DISABLED: String = "disabled"
const THEME_STYLE_PANEL: String = "panel"

const THEME_FONT_COLOR: String = "font_color"
const THEME_FONT_HOVER_COLOR: String = "font_hover_color"
const THEME_FONT_PRESSED_COLOR: String = "font_pressed_color"
const THEME_FONT_DISABLED_COLOR: String = "font_disabled_color"
const THEME_FONT_SIZE: String = "font_size"


static func apply_background(background: ColorRect) -> void:
	background.color = Color(COLOR_BACKGROUND)


static func apply_title(label: Label) -> void:
	label.add_theme_color_override(THEME_FONT_COLOR, Color(COLOR_TITLE_TEXT))
	label.add_theme_font_size_override(THEME_FONT_SIZE, TITLE_FONT_SIZE)


static func apply_main_title(label: Label) -> void:
	label.add_theme_color_override(THEME_FONT_COLOR, Color(COLOR_TITLE_TEXT))
	label.add_theme_font_size_override(THEME_FONT_SIZE, MAIN_TITLE_FONT_SIZE)


static func apply_normal_label(label: Label) -> void:
	label.add_theme_color_override(THEME_FONT_COLOR, Color(COLOR_LABEL_TEXT))
	label.add_theme_font_size_override(THEME_FONT_SIZE, LABEL_FONT_SIZE)


static func apply_message_label(label: Label) -> void:
	label.add_theme_color_override(THEME_FONT_COLOR, Color(COLOR_MESSAGE_TEXT))
	label.add_theme_font_size_override(THEME_FONT_SIZE, MESSAGE_FONT_SIZE)


static func apply_deck_panel(panel: PanelContainer) -> void:
	panel.add_theme_stylebox_override(
		THEME_STYLE_PANEL,
		_make_style(COLOR_PANEL_BACKGROUND, COLOR_PANEL_BORDER, BORDER_WIDTH_NORMAL)
	)


static func apply_monster_button(button: Button, card: Dictionary) -> void:
	_apply_button_style(
		button,
		COLOR_WHITE_CARD_BACKGROUND,
		COLOR_MONSTER_BORDER,
		card_text_color(card),
		BORDER_WIDTH_NORMAL,
		CARD_FONT_SIZE
	)


static func apply_loot_button(button: Button, card: Dictionary) -> void:
	_apply_button_style(
		button,
		COLOR_WHITE_CARD_BACKGROUND,
		COLOR_LOOT_BORDER,
		card_text_color(card),
		BORDER_WIDTH_NORMAL,
		CARD_FONT_SIZE
	)


static func apply_hidden_button(button: Button) -> void:
	_apply_button_style(
		button,
		COLOR_HIDDEN_BACKGROUND,
		COLOR_HIDDEN_BORDER,
		COLOR_HIDDEN_TEXT,
		BORDER_WIDTH_NORMAL,
		CARD_FONT_SIZE
	)


static func apply_empty_button(button: Button) -> void:
	_apply_button_style(
		button,
		COLOR_EMPTY_BACKGROUND,
		COLOR_EMPTY_BORDER,
		COLOR_EMPTY_TEXT,
		BORDER_WIDTH_NORMAL,
		CARD_FONT_SIZE
	)


static func apply_hand_button(button: Button, is_selected: bool, card: Dictionary) -> void:
	if is_selected:
		_apply_button_style(
			button,
			COLOR_WHITE_CARD_BACKGROUND,
			COLOR_SELECTED_BORDER,
			card_text_color(card),
			BORDER_WIDTH_SELECTED,
			HAND_CARD_FONT_SIZE
		)
	else:
		_apply_button_style(
			button,
			COLOR_WHITE_CARD_BACKGROUND,
			COLOR_WHITE_CARD_BORDER,
			card_text_color(card),
			BORDER_WIDTH_NORMAL,
			HAND_CARD_FONT_SIZE
		)


static func apply_action_button(button: Button) -> void:
	_apply_button_style(
		button,
		COLOR_ACTION_BACKGROUND,
		COLOR_ACTION_BORDER,
		COLOR_CARD_TEXT,
		BORDER_WIDTH_NORMAL,
		BUTTON_FONT_SIZE
	)


static func apply_reset_button(button: Button) -> void:
	_apply_button_style(
		button,
		COLOR_RESET_BACKGROUND,
		COLOR_RESET_BORDER,
		COLOR_CARD_TEXT,
		BORDER_WIDTH_NORMAL,
		BUTTON_FONT_SIZE
	)


static func _apply_button_style(
	button: Button,
	background_color: String,
	border_color: String,
	text_color: String,
	border_width: int,
	font_size: int
) -> void:
	var normal_style: StyleBoxFlat = _make_style(background_color, border_color, border_width)

	button.add_theme_stylebox_override(THEME_STYLE_NORMAL, normal_style)
	button.add_theme_stylebox_override(THEME_STYLE_HOVER, normal_style)
	button.add_theme_stylebox_override(THEME_STYLE_PRESSED, normal_style)
	button.add_theme_stylebox_override(THEME_STYLE_DISABLED, normal_style)

	button.add_theme_color_override(THEME_FONT_COLOR, Color(text_color))
	button.add_theme_color_override(THEME_FONT_HOVER_COLOR, Color(text_color))
	button.add_theme_color_override(THEME_FONT_PRESSED_COLOR, Color(text_color))
	button.add_theme_color_override(THEME_FONT_DISABLED_COLOR, Color(text_color))

	button.add_theme_font_size_override(THEME_FONT_SIZE, font_size)


static func _make_style(
	background_color: String,
	border_color: String,
	border_width: int
) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()

	style.bg_color = Color(background_color)
	style.border_color = Color(border_color)
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(CORNER_RADIUS)

	return style


static func card_text_color(card: Dictionary) -> String:
	if card.is_empty():
		return COLOR_SPADES_TEXT

	if CardUtils.is_joker(card):
		return COLOR_JOKER_TEXT

	var suit: String = card[CardUtils.CARD_KEY_SUIT]

	if suit == CardUtils.SUIT_HEARTS:
		return COLOR_HEARTS_TEXT

	if suit == CardUtils.SUIT_DIAMONDS:
		return COLOR_DIAMONDS_TEXT

	if suit == CardUtils.SUIT_CLUBS:
		return COLOR_CLUBS_TEXT

	return COLOR_SPADES_TEXT


static func card_text_color_value(card: Dictionary) -> Color:
	return Color(card_text_color(card))


static func card_text_color_bbcode(card: Dictionary) -> String:
	return card_text_color(card)


static func card_bbcode(card: Dictionary) -> String:
	return "[color=%s]%s[/color]" % [
		card_text_color_bbcode(card),
		CardUtils.card_text(card)
	]


static func apply_life_label(label: Label) -> void:
	label.add_theme_color_override(THEME_FONT_COLOR, Color(COLOR_HEARTS_TEXT))
	label.add_theme_font_size_override(THEME_FONT_SIZE, LIFE_FONT_SIZE)


static func apply_variation_button(button: Button, is_selected: bool) -> void:
	if is_selected:
		_apply_button_style(
			button,
			COLOR_VARIATION_SELECTED_BACKGROUND,
			COLOR_VARIATION_SELECTED_BORDER,
			COLOR_CARD_TEXT,
			BORDER_WIDTH_SELECTED,
			BUTTON_FONT_SIZE
		)
	else:
		_apply_button_style(
			button,
			COLOR_VARIATION_BACKGROUND,
			COLOR_VARIATION_BORDER,
			COLOR_CARD_TEXT,
			BORDER_WIDTH_NORMAL,
			BUTTON_FONT_SIZE
		)
