extends Control

var background: ColorRect
var current_screen: Control


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_build_background()
	_show_main_menu()


func _build_background() -> void:
	background = ColorRect.new()
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	UIStyle.apply_background(background)


func _set_screen(screen: Control) -> void:
	if current_screen != null:
		current_screen.queue_free()

	current_screen = screen
	add_child(current_screen)
	current_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	current_screen.move_to_front()


func _show_main_menu() -> void:
	var screen: MainMenuView = MainMenuView.new()

	_set_screen(screen)

	screen.setup()
	screen.play_pressed.connect(_show_layout_select)
	screen.rules_pressed.connect(_show_rules)
	screen.quit_pressed.connect(_quit_game)


func _show_layout_select() -> void:
	var screen: LayoutSelectView = LayoutSelectView.new()

	_set_screen(screen)

	screen.setup()
	screen.layout_selected.connect(_show_variation_select)
	screen.back_pressed.connect(_show_main_menu)


func _show_variation_select(layout_id: String) -> void:
	var screen: VariationSelectView = VariationSelectView.new()

	_set_screen(screen)

	screen.setup(layout_id)

	screen.variations_selected.connect(
		func(variation_ids: Array[String]) -> void:
			_show_game(layout_id, variation_ids)
	)

	screen.back_pressed.connect(_show_layout_select)


func _show_rules() -> void:
	var screen: RulesView = RulesView.new()

	_set_screen(screen)

	screen.setup()
	screen.back_pressed.connect(_show_main_menu)


func _show_game(layout_id: String, variation_ids: Array[String]) -> void:
	var screen: GameScreen = GameScreen.new()

	_set_screen(screen)

	screen.setup(layout_id, variation_ids)
	screen.main_menu_pressed.connect(_show_main_menu)


func _quit_game() -> void:
	get_tree().quit()
