class_name PlayerPanel
extends PanelContainer

signal pressed()
signal delete_pressed()
signal move_button_pressed()
signal move_button_released()

@onready var button: Button = %Button
@onready var flag_texture_rect: TextureRect = %FlagTextureRect
@onready var nickname_label: Label = %NicknameLabel
@onready var delete_button_margin: MarginContainer = %DeleteButtonMargin
@onready var delete_button: TextureButton = %DeleteButton
@onready var move_button: Button = %MoveButton
@onready var order_index_label: Label = %OrderIndexLabel

var player: Player


func populate(player_: Player) -> void:
	player = player_
	nickname_label.text = player.nickname


func show_delete_button() -> void:
	delete_button_margin.show()


func show_move_button() -> void:
	move_button.show()


func show_order_index() -> void:
	order_index_label.show()


func enable_toggle_mode() -> void:
	button.toggle_mode = true


func is_pressed() -> bool:
	return button.button_pressed


func toggle(value: bool) -> void:
	button.button_pressed = value


func _ready() -> void:
	button.pressed.connect(pressed.emit)
	delete_button.pressed.connect(delete_pressed.emit)
	move_button.pressed.connect(move_button_pressed.emit)
	move_button.button_up.connect(move_button_released.emit)
