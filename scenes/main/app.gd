class_name App
extends Control

@onready var current_screen_container: Control = %CurrentScreenContainer
@onready var loading_label: Label = %LoadingLabel
@onready var loading_sign: MarginContainer = %LoadingSign

static var app: App


static func change_screen(new_screen_path: String) -> void:
	app._change_screen(new_screen_path)


static func show_loading_sign(message: String) -> void:
	app._show_loading_sign(message)


static func hide_loading_sign() -> void:
	app._hide_loading_sign()


func _ready() -> void:
	app = self
	loading_sign.hide()


func _change_screen(new_screen_path: String) -> void:
	if current_screen_container.get_child_count() > 0:
		current_screen_container.get_child(0).queue_free()
	
	var new_screen_scene: PackedScene = load(new_screen_path)
	var new_screen: Control = new_screen_scene.instantiate()
	
	current_screen_container.add_child(new_screen)


func _show_loading_sign(message: String) -> void:
	loading_label.text = message
	loading_sign.show()


func _hide_loading_sign() -> void:
	loading_sign.hide()
