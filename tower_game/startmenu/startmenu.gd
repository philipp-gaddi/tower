extends Control

var options

const USER_OPTIONS_RESOURCE_PATH = "user://options.tres"
const OPTIONS_DEFAULT_RESOURCE_PATH = "res://startmenu/startmenuoptions.tres"

func _ready():
	$OptionsScreen.visible = false
	$PanelContainer/MarginContainer/Menu/Start.grab_focus()
	
	# load saved options
	reset_options()
	
	# init language list
	for l in TranslationServer.get_loaded_locales():
		$OptionsScreen/MarginContainer/VBoxContainer/Language/LanguageOptions.add_item(l)
	
	var current_locale = options['locale']
	var current_locale_id = TranslationServer.get_loaded_locales().find(current_locale) 
	$OptionsScreen/MarginContainer/VBoxContainer/Language/LanguageOptions.select(current_locale_id)
	
	
	# init screen resolution list
	for r in options['resolutions']:
		$OptionsScreen/MarginContainer/VBoxContainer/Resolution/ResolutionOptions.add_item(r)
	$OptionsScreen/MarginContainer/VBoxContainer/Resolution/ResolutionOptions.select(options['resolution_selected'])
	
	# init fullscreen setting
	$OptionsScreen/MarginContainer/VBoxContainer/Fullscreen/FullscreenCheckButton.pressed = options['fullscreen']
	
	apply_options()


func apply_options():
	
	# set language
	TranslationServer.set_locale(options['locale'])
	
	# set resolution
	
	var resolution = options['resolutions'][options['resolution_selected']].split('x')
	
	var resolution_vector = Vector2(
		int(resolution[0]),
		int(resolution[1])
	)
	OS.window_size = resolution_vector
	
	# set fullscreen
	OS.window_fullscreen = options['fullscreen']


func reset_options():
	
	if ResourceLoader.exists(USER_OPTIONS_RESOURCE_PATH):
		options = ResourceLoader.load(USER_OPTIONS_RESOURCE_PATH, "", true)
	else:
		options = ResourceLoader.load(OPTIONS_DEFAULT_RESOURCE_PATH, "", true)


func reset_options_to_default():
	
	options = ResourceLoader.load(OPTIONS_DEFAULT_RESOURCE_PATH, "", true)


func save_options():
	
	return ResourceSaver.save(USER_OPTIONS_RESOURCE_PATH, options)


func reset_options_ui():
	
	var current_locale = options['locale']
	var current_locale_id = TranslationServer.get_loaded_locales().find(current_locale) 
	$OptionsScreen/MarginContainer/VBoxContainer/Language/LanguageOptions.select(current_locale_id)
	
	$OptionsScreen/MarginContainer/VBoxContainer/Resolution/ResolutionOptions.select(options['resolution_selected'])
	
	$OptionsScreen/MarginContainer/VBoxContainer/Fullscreen/FullscreenCheckButton.pressed = options['fullscreen']


func _on_Quit_button_up():
	get_tree().quit()


func _on_Start_button_up():
	var error = get_tree().change_scene("res://world/testworld.tscn")
	print_debug('starting game status: ' + str(error))


func _on_Options_button_up():
	$OptionsScreen.visible = !$OptionsScreen.visible


func _on_LanguageOptions_item_selected(index):
	
	var locale_selected = TranslationServer.get_loaded_locales()[index]
	
	options['locale'] = locale_selected


func _on_Apply_button_up():
	apply_options()
	save_options()


func _on_Reset_button_up():
	reset_options_to_default()
	reset_options_ui()
	apply_options()
	save_options()


func _on_Revert_button_up():
	reset_options()
	reset_options_ui()


func _on_ResolutionOptions_item_selected(index):
	options['resolution_selected'] = index


func _on_FullscreenCheckButton_toggled(button_pressed):
	options['fullscreen'] = button_pressed
