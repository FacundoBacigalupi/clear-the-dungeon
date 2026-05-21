extends Control
class_name RulesView

signal back_pressed


func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var margin: MarginContainer = MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_LEFT,
		UIConfig.RULES_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_TOP,
		UIConfig.RULES_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_RIGHT,
		UIConfig.RULES_SCREEN_MARGIN
	)
	margin.add_theme_constant_override(
		UIConfig.THEME_MARGIN_BOTTOM,
		UIConfig.RULES_SCREEN_MARGIN
	)

	var root: VBoxContainer = VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.MAIN_SEPARATION
	)
	margin.add_child(root)

	var title: Label = Label.new()
	title.text = UIConfig.TEXT_RULES_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_title(title)
	root.add_child(title)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(
		UIConfig.RULES_TEXT_WIDTH,
		UIConfig.RULES_TEXT_HEIGHT
	)
	scroll.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)

	var rules_label: RichTextLabel = RichTextLabel.new()
	rules_label.custom_minimum_size = Vector2(
		UIConfig.RULES_TEXT_WIDTH,
		UIConfig.RULES_TEXT_HEIGHT
	)
	rules_label.bbcode_enabled = true
	rules_label.text = UIConfig.TEXT_RULES_BODY
	rules_label.fit_content = true
	rules_label.scroll_active = false
	rules_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rules_label.add_theme_color_override(UIStyle.THEME_FONT_COLOR, Color(UIStyle.COLOR_LABEL_TEXT))
	rules_label.add_theme_font_size_override(UIStyle.THEME_FONT_SIZE, UIStyle.LABEL_FONT_SIZE)
	scroll.add_child(rules_label)

	var back_margin: Control = Control.new()
	back_margin.custom_minimum_size = Vector2(
		UIConfig.ZERO_FLOAT,
		UIConfig.RULES_BACK_TOP_MARGIN
	)
	root.add_child(back_margin)

	var back_button: Button = Button.new()
	back_button.custom_minimum_size = Vector2(
		UIConfig.MENU_BUTTON_WIDTH,
		UIConfig.MENU_BUTTON_HEIGHT
	)
	back_button.text = UIConfig.TEXT_BACK
	back_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_action_button(back_button)
	back_button.pressed.connect(_on_back_pressed)
	root.add_child(back_button)


func _on_back_pressed() -> void:
	back_pressed.emit()
