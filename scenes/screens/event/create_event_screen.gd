extends EventDataScreenBase


func _submit_form() -> bool:
	var event_create := EventCreate.new()
	
	event_create.name = name_line_edit.text
	event_create.country_code = country_line_edit.text
	event_create.location = location_line_edit.text
	event_create.start_date = "%s-%s-%s" % [date_year_line_edit.text, date_month_line_edit.text, date_day_line_edit.text]
	event_create.start_time = "%s:%s" % [time_hour_line_edit.text, time_minute_line_edit.text]
	event_create.description = description_text_edit.text
	
	var event: Event = await EventsRouter.create_event(event_create)
	
	if not event:
		return false
	
	if logo_path:
		event = await EventsRouter.upload_event_logo(event.id, logo_path)
		
		if not event:
			return false
	
	Globals.current_event = event
	
	return true
