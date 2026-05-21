extends Control
class_name LayoutSelectView

signal layout_selected(layout_id: String)
signal back_pressed


func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var margin: MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_LEFT,
		UIConfig.LAYOUT_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_TOP,
		UIConfig.LAYOUT_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_RIGHT,
		UIConfig.LAYOUT_SELECT_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_BOTTOM,
		UIConfig.LAYOUT_SELECT_SCREEN_MARGIN
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
	title.text = UIConfig.TEXT_LAYOUT_SELECT_TITLE
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

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.LAYOUT_OPTIONS_MIN_HEIGHT
	)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	var layout_flow: HFlowContainer = HFlowContainer.new()
	layout_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout_flow.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout_flow.alignment = FlowContainer.ALIGNMENT_CENTER
	layout_flow.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.LAYOUT_OPTIONS_HORIZONTAL_SEPARATION
	)
	layout_flow.add_theme_constant_override(
		"v_separation",
		UIConfig.LAYOUT_OPTIONS_VERTICAL_SEPARATION
	)
	scroll.add_child(layout_flow)

	for layout in LayoutConfig.get_layouts():
		var layout_button: Button = Button.new()
		layout_button.custom_minimum_size = Vector2(
			UIConfig.LAYOUT_BUTTON_WIDTH,
			UIConfig.LAYOUT_BUTTON_HEIGHT
		)
		layout_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

		var layout_id: String = layout[LayoutConfig.KEY_ID]
		var layout_name: String = layout[LayoutConfig.KEY_NAME]
		var layout_graphic: String = layout[LayoutConfig.KEY_GRAPHIC]

		layout_button.text = UIConfig.TEXT_LAYOUT_BUTTON_FORMAT % [
			layout_name,
			layout_graphic
		]
		UIStyle.apply_action_button(layout_button)
		layout_button.pressed.connect(_on_layout_pressed.bind(layout_id))
		layout_flow.add_child(layout_button)

	var back_margin: Control = Control.new()
	back_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.LAYOUT_BACK_TOP_MARGIN
	)
	root.add_child(back_margin)

	var back_button: Button = Button.new()
	back_button.custom_minimum_size = Vector2(
		UIConfig.MENU_BUTTON_WIDTH,
		UIConfig.MENU_BUTTON_HEIGHT
	)
	back_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_button.text = UIConfig.TEXT_BACK
	UIStyle.apply_action_button(back_button)
	back_button.pressed.connect(_on_back_pressed)
	root.add_child(back_button)


func _on_layout_pressed(layout_id: String) -> void:
	layout_selected.emit(layout_id)


func _on_back_pressed() -> void:
	back_pressed.emit()
