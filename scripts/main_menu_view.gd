extends Control
class_name MainMenuView

signal play_pressed
signal rules_pressed
signal quit_pressed


func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center: CenterContainer = CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var root: VBoxContainer = VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.MENU_BUTTON_SEPARATION
	)
	center.add_child(root)

	var title: Label = Label.new()
	title.text = UIConfig.TEXT_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_main_title(title)
	root.add_child(title)

	var title_margin: Control = Control.new()
	title_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.SCREEN_TITLE_BOTTOM_MARGIN
	)
	root.add_child(title_margin)

	var play_button: Button = _make_menu_button(UIConfig.TEXT_MENU_PLAY)
	play_button.pressed.connect(_on_play_pressed)
	root.add_child(play_button)

	var rules_button: Button = _make_menu_button(UIConfig.TEXT_MENU_RULES)
	rules_button.pressed.connect(_on_rules_pressed)
	root.add_child(rules_button)

	var quit_button: Button = _make_menu_button(UIConfig.TEXT_MENU_QUIT)
	UIStyle.apply_reset_button(quit_button)
	quit_button.pressed.connect(_on_quit_pressed)
	root.add_child(quit_button)


func _make_menu_button(text: String) -> Button:
	var button: Button = Button.new()
	button.custom_minimum_size = Vector2(
		UIConfig.MENU_BUTTON_WIDTH,
		UIConfig.MENU_BUTTON_HEIGHT
	)
	button.text = text
	UIStyle.apply_action_button(button)
	return button


func _on_play_pressed() -> void:
	play_pressed.emit()


func _on_rules_pressed() -> void:
	rules_pressed.emit()


func _on_quit_pressed() -> void:
	quit_pressed.emit()
