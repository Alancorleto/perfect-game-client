extends Control

@onready var events_container: VBoxContainer = %EventsContainer

const EventPanelScene: PackedScene = preload("res://scenes/screens/select_event/event_panel.tscn")


func _ready() -> void:
	App.show_loading_sign("Loading events...")

	var events: Array[Event] = await EventsRouter.list_events()

	for event: Event in events:
		var event_panel: EventPanel = EventPanelScene.instantiate()
		events_container.add_child(event_panel)
		event_panel.populate(event)

	App.hide_loading_sign()
