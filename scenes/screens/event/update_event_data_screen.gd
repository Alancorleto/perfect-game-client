extends EventDataScreenBase


func _populate() -> void:
	name_line_edit.text = Globals.current_event.name
	country_line_edit.text = Globals.current_event.country_code
	location_line_edit.text = Globals.current_event.location
	
	var start_date: String = Globals.current_event.start_date
	date_day_line_edit.text = start_date.substr(8, 2)
	date_month_line_edit.text = start_date.substr(5, 2)
	date_year_line_edit.text = start_date.substr(0, 4)
	
	var start_time: String = Globals.current_event.start_time
	time_hour_line_edit.text = start_time.substr(0, 2)
	time_minute_line_edit.text = start_time.substr(3, 2)
	
	description_text_edit.text = Globals.current_event.description
	
	logo.texture = Globals.current_event.logo


func _submit_form() -> bool:
	var event_update := EventUpdate.new()
	
	event_update.name = name_line_edit.text
	event_update.country_code = country_line_edit.text
	event_update.location = location_line_edit.text
	event_update.start_date = "%s-%s-%s" % [date_year_line_edit.text, date_month_line_edit.text, date_day_line_edit.text]
	event_update.start_time = "%s:%s" % [time_hour_line_edit.text, time_minute_line_edit.text]
	event_update.description = description_text_edit.text
	
	var event: Event = await EventsRouter.update_event(Globals.current_event.id, event_update)
	
	if not event:
		return false
	
	if logo_path:
		event = await EventsRouter.upload_event_logo(event.id, logo_path)
		
		if not event:
			return false
	
	Globals.current_event = event
	
	return true
