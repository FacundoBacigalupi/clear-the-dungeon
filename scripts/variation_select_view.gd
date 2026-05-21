extends Control
class_name VariationSelectView

signal variations_selected(variation_ids: Array[String])
signal back_pressed

var selected_layout_id: String = LayoutConfig.DEFAULT_LAYOUT_ID
var selected_variation_ids: Array[String] = []


func setup(layout_id: String) -> void:
	selected_layout_id = layout_id

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var margin: MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_LEFT,
		UIConfig.VARIATION_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_TOP,
		UIConfig.VARIATION_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_RIGHT,
		UIConfig.VARIATION_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_BOTTOM,
		UIConfig.VARIATION_SELECT_SCREEN_MARGIN
	)

	var root: VBoxContainer = VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.MAIN_SEPARATION
	)
	margin.add_child(root)

	var title: Label = Label.new()
	title.text = UIConfig.TEXT_VARIATION_SELECT_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_title(title)
	root.add_child(title)

	var title_margin: Control = Control.new()
	title_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.SCREEN_TITLE_BOTTOM_MARGIN
	)
	root.add_child(title_margin)

	var variation_box: VBoxContainer = VBoxContainer.new()
	variation_box.alignment = BoxContainer.ALIGNMENT_CENTER
	variation_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	variation_box.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.VARIATION_OPTION_SEPARATION
	)
	root.add_child(variation_box)

	for variation in VariationConfig.get_variations():
		var variation_id: String = variation[VariationConfig.KEY_ID]
		var variation_name: String = variation[VariationConfig.KEY_NAME]

		var option: Button = Button.new()
		option.toggle_mode = true
		option.custom_minimum_size = Vector2(
			UIConfig.VARIATION_BUTTON_WIDTH,
			UIConfig.VARIATION_BUTTON_HEIGHT
		)
		option.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		option.text = variation_name
		option.focus_mode = Control.FOCUS_NONE
		UIStyle.apply_variation_button(option, false)
		option.toggled.connect(_on_variation_toggled.bind(option, variation_id))
		variation_box.add_child(option)

	var buttons_margin: Control = Control.new()
	buttons_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.VARIATION_BUTTONS_TOP_MARGIN
	)
	root.add_child(buttons_margin)

	var buttons_row: HBoxContainer = HBoxContainer.new()
	buttons_row.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons_row.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.MENU_BUTTON_SEPARATION
	)
	root.add_child(buttons_row)

	var back_button: Button = Button.new()
	back_button.custom_minimum_size = Vector2(
		UIConfig.MENU_BUTTON_WIDTH,
		UIConfig.MENU_BUTTON_HEIGHT
	)
	back_button.text = UIConfig.TEXT_BACK
	UIStyle.apply_action_button(back_button)
	back_button.pressed.connect(_on_back_pressed)
	buttons_row.add_child(back_button)

	var play_button: Button = Button.new()
	play_button.custom_minimum_size = Vector2(
		UIConfig.MENU_BUTTON_WIDTH,
		UIConfig.MENU_BUTTON_HEIGHT
	)
	play_button.text = UIConfig.TEXT_MENU_PLAY
	UIStyle.apply_action_button(play_button)
	play_button.pressed.connect(_on_play_pressed)
	buttons_row.add_child(play_button)


func _on_variation_toggled(is_pressed: bool, button: Button, variation_id: String) -> void:
	if is_pressed:
		if not selected_variation_ids.has(variation_id):
			selected_variation_ids.append(variation_id)
	else:
		selected_variation_ids.erase(variation_id)

	UIStyle.apply_variation_button(button, is_pressed)


func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_play_pressed() -> void:
	var result: Array[String] = selected_variation_ids.duplicate()
	variations_selected.emit(result)
