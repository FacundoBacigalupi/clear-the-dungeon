extends Control
class_name GameScreen

signal main_menu_pressed

var selected_layout_id: String = LayoutConfig.DEFAULT_LAYOUT_ID

var game: GameState = GameState.new()

var ui_root: VBoxContainer
var side_panel: SidePanel
var board_view: BoardView
var hand_panel: HandPanel
var message_label: Label

var selected_hand_indices: Array[int] = []

func setup(layout_id: String) -> void:
	selected_layout_id = layout_id
	game.configure_layout(selected_layout_id)

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_build_ui()

	get_tree().root.size_changed.connect(_on_window_size_changed)

	_start_new_game()

	call_deferred("_update_layout")


func _build_ui() -> void:
	ui_root = VBoxContainer.new()
	add_child(ui_root)

	ui_root.alignment = BoxContainer.ALIGNMENT_CENTER
	ui_root.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.MAIN_SEPARATION
	)

	var title: Label = Label.new()
	title.text = UIConfig.TEXT_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_title(title)
	ui_root.add_child(title)

	var content: HBoxContainer = HBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content.add_theme_constant_override(
		UIConfig.THEME_SEPARATION,
		UIConfig.CONTENT_SEPARATION
	)
	ui_root.add_child(content)

	side_panel = SidePanel.new()
	side_panel.setup()
	side_panel.reset_pressed.connect(_on_reset_pressed)
	side_panel.main_menu_pressed.connect(_on_main_menu_pressed)
	content.add_child(side_panel)

	board_view = BoardView.new()
	board_view.setup(game.row_pattern)
	board_view.slot_pressed.connect(_on_board_slot_pressed)
	content.add_child(board_view)

	hand_panel = HandPanel.new()
	hand_panel.setup()
	hand_panel.hand_card_pressed.connect(_on_hand_card_pressed)
	hand_panel.end_turn_pressed.connect(_on_end_turn_pressed)
	content.add_child(hand_panel)

	message_label = Label.new()
	message_label.text = UIConfig.TEXT_CHOOSE_CARD
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	UIStyle.apply_message_label(message_label)
	ui_root.add_child(message_label)


func _start_new_game() -> void:
	selected_hand_indices.clear()

	game.new_game(selected_layout_id)

	var draw_message: String = game.draw_hand()

	_update_all_views()

	if game.hand.size() > GameState.EMPTY_COUNT:
		message_label.text = UIConfig.TEXT_INITIAL_MESSAGE
	else:
		message_label.text = draw_message


func _on_reset_pressed() -> void:
	_start_new_game()
	message_label.text = UIConfig.TEXT_GAME_RESET


func _on_main_menu_pressed() -> void:
	main_menu_pressed.emit()


func _on_hand_card_pressed(index: int) -> void:
	if game.game_finished:
		return

	if index >= game.hand.size():
		return

	var selected_position: int = selected_hand_indices.find(index)

	if selected_position == UIConfig.NOT_FOUND_INDEX:
		selected_hand_indices.append(index)
	else:
		selected_hand_indices.remove_at(selected_position)

	_update_all_views()


func _on_board_slot_pressed(row: int, col: int) -> void:
	if game.game_finished:
		return

	if not game.is_slot_uncovered(row, col):
		message_label.text = UIConfig.TEXT_HIDDEN_STATUS
		return

	if game.is_slot_empty(row, col):
		message_label.text = UIConfig.TEXT_SLOT_EMPTY_STATUS
		return

	if selected_hand_indices.is_empty():
		if game.is_slot_loot(row, col):
			var loot_message: String = game.take_loot(row, col)

			_update_all_views()
			message_label.text = loot_message
			
			_auto_end_turn_if_needed()
			return

		message_label.text = board_view.get_slot_status_text(game, row, col)
		return

	var result_message: String = game.place_hand_cards_on_slot(selected_hand_indices, row, col)

	selected_hand_indices.clear()

	_update_all_views()
	message_label.text = result_message
	
	_auto_end_turn_if_needed()


func _on_end_turn_pressed() -> void:
	if game.game_finished:
		return

	selected_hand_indices.clear()

	var result_message: String = game.draw_hand()

	_update_all_views()
	message_label.text = result_message


func _update_all_views() -> void:
	side_panel.refresh(game)
	board_view.refresh(game)
	hand_panel.refresh(game, selected_hand_indices)

	call_deferred("_update_layout")

func _on_window_size_changed() -> void:
	_update_layout()

func _update_layout() -> void:
	if ui_root == null:
		return

	var viewport_size: Vector2 = get_viewport_rect().size
	var desired_size: Vector2 = ui_root.get_combined_minimum_size()

	if desired_size == UIConfig.ZERO_VECTOR:
		return

	var padding_size: Vector2 = Vector2(
		UIConfig.LAYOUT_PADDING * UIConfig.DOUBLE_MULTIPLIER,
		UIConfig.LAYOUT_PADDING * UIConfig.DOUBLE_MULTIPLIER
	)

	var available_size: Vector2 = viewport_size - padding_size

	available_size.x = max(available_size.x, UIConfig.MIN_AVAILABLE_SIZE)
	available_size.y = max(available_size.y, UIConfig.MIN_AVAILABLE_SIZE)

	var scale_x: float = available_size.x / desired_size.x
	var scale_y: float = available_size.y / desired_size.y

	var layout_scale: float = clamp(
		min(scale_x, scale_y),
		UIConfig.MIN_LAYOUT_SCALE,
		UIConfig.MAX_LAYOUT_SCALE
	)

	ui_root.scale = Vector2(layout_scale, layout_scale)
	ui_root.size = desired_size

	var scaled_size: Vector2 = desired_size * layout_scale

	ui_root.position = (viewport_size - scaled_size) / UIConfig.CENTER_DIVISOR

func _auto_end_turn_if_needed() -> void:
	if game.game_finished:
		return

	if game.hand.size() > GameState.EMPTY_COUNT:
		return

	if game.has_accessible_loot():
		return

	var result_message: String = game.draw_hand()

	_update_all_views()
	message_label.text = UIConfig.TEXT_AUTO_END_TURN_PREFIX + result_message
