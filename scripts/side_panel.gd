extends VBoxContainer
class_name SidePanel

signal reset_pressed
signal main_menu_pressed

var damage_label: Label
var power_deck_label: Label
var clear_pile_label: Label
var reset_button: Button
var main_menu_button: Button

func setup() -> void:
	custom_minimum_size = Vector2(UIConfig.LEFT_PANEL_WIDTH, UIConfig.ZERO_FLOAT)
	add_theme_constant_override(UIConfig.THEME_SEPARATION, UIConfig.PANEL_SEPARATION)
	
	main_menu_button = Button.new()
	main_menu_button.custom_minimum_size = Vector2(
		UIConfig.RESET_BUTTON_WIDTH,
		UIConfig.RESET_BUTTON_HEIGHT
	)
	main_menu_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	main_menu_button.text = UIConfig.TEXT_MAIN_MENU
	UIStyle.apply_action_button(main_menu_button)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	add_child(main_menu_button)
	
	reset_button = Button.new()
	reset_button.custom_minimum_size = Vector2(
		UIConfig.RESET_BUTTON_WIDTH,
		UIConfig.RESET_BUTTON_HEIGHT
	)
	reset_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	reset_button.text = UIConfig.TEXT_RESET
	reset_button.pressed.connect(_on_reset_pressed)
	UIStyle.apply_reset_button(reset_button)
	add_child(reset_button)
	
	var power_deck_panel: PanelContainer = PanelContainer.new()
	power_deck_panel.custom_minimum_size = Vector2(
		UIConfig.POWER_DECK_WIDTH,
		UIConfig.POWER_DECK_HEIGHT
	)
	power_deck_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_deck_panel(power_deck_panel)
	add_child(power_deck_panel)

	power_deck_label = Label.new()
	power_deck_label.text = UIConfig.TEXT_POWER_DECK_FORMAT % GameState.EMPTY_COUNT
	power_deck_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	power_deck_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(power_deck_label)
	power_deck_panel.add_child(power_deck_label)

	clear_pile_label = Label.new()
	clear_pile_label.text = UIConfig.TEXT_CLEAR_PILE_FORMAT % GameState.EMPTY_COUNT
	clear_pile_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.apply_normal_label(clear_pile_label)
	add_child(clear_pile_label)

	damage_label = Label.new()
	damage_label.text = _hearts_text(GameState.MAX_DAMAGE)
	damage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_life_label(damage_label)
	add_child(damage_label)


func refresh(game: GameState) -> void:
	var remaining_hearts: int = max(
		GameState.MAX_DAMAGE - game.damage_bar.size(),
		GameState.EMPTY_COUNT
	)

	damage_label.text = _hearts_text(remaining_hearts)
	power_deck_label.text = UIConfig.TEXT_POWER_DECK_FORMAT % game.power_deck.size()
	clear_pile_label.text = UIConfig.TEXT_CLEAR_PILE_FORMAT % game.clear_pile.size()


func _on_reset_pressed() -> void:
	reset_pressed.emit()


func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()


func _hearts_text(heart_count: int) -> String:
	if heart_count <= GameState.EMPTY_COUNT:
		return UIConfig.TEXT_NO_LIFE

	var text: String = UIConfig.TEXT_NO_LIFE

	for heart_index in range(heart_count):
		if heart_index > GameState.EMPTY_COUNT:
			if heart_index % UIConfig.LIFE_HEARTS_PER_ROW == GameState.EMPTY_COUNT:
				text += UIConfig.TEXT_LIFE_LINE_BREAK
			else:
				text += UIConfig.TEXT_LIFE_SEPARATOR

		text += UIConfig.TEXT_LIFE_HEART

	return text
