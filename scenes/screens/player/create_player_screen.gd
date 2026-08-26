extends PlayerScreenBase


func _submit_form() -> bool:
	var player_create := PlayerCreate.new()

	player_create.nickname = nickname_line_edit.text
	player_create.name = name_line_edit.text
	player_create.country_code = country_line_edit.text
	player_create.team_name = team_name_line_edit.text
	player_create.birth_date = "%s-%s-%s" % [birth_date_year_line_edit.text, birth_date_month_line_edit.text, birth_date_day_line_edit.text]
	player_create.city = city_line_edit.text
	player_create.user_id = Globals.current_user.id

	var player: Player = await PlayersRouter.create_player(player_create)
	
	if player:
		if profile_picture_path:
			player = await PlayersRouter.upload_profile_picture(player.id, profile_picture_path)
			
			if not player:
				return false
		
		Globals.current_player = player
		
		return true
	else:
		return false
