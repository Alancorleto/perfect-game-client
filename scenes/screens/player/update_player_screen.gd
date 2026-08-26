extends PlayerScreenBase


func _populate() -> void:
	nickname_line_edit.text = Globals.current_player.nickname
	name_line_edit.text = Globals.current_player.name
	country_line_edit.text = Globals.current_player.country_code
	team_name_line_edit.text = Globals.current_player.team_name
	
	var birth_date: String = Globals.current_player.birth_date
	birth_date_day_line_edit.text = birth_date.substr(8, 2)
	birth_date_month_line_edit.text = birth_date.substr(5, 2)
	birth_date_year_line_edit.text = birth_date.substr(0, 4)
	
	city_line_edit.text = Globals.current_player.city
	
	profile_picture.texture = Globals.current_player.profile_picture


func _submit_form() -> bool:
	var player_update := PlayerUpdate.new()

	player_update.nickname = nickname_line_edit.text
	player_update.name = name_line_edit.text
	player_update.country_code = country_line_edit.text
	player_update.team_name = team_name_line_edit.text
	player_update.birth_date = "%s-%s-%s" % [birth_date_year_line_edit.text, birth_date_month_line_edit.text, birth_date_day_line_edit.text]
	player_update.city = city_line_edit.text

	var player: Player = await PlayersRouter.update_player(
		Globals.current_player.id,
		player_update,
	)
	
	if player:
		if profile_picture_path:
			player = await PlayersRouter.upload_profile_picture(player.id, profile_picture_path)
			
			if not player:
				return false
			
		await player.try_load_profile_picture()
		
		Globals.current_player = player
		
		return true
	else:
		return false
