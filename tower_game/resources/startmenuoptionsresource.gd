extends Resource
class_name StartmenuOptions

export(String, 'en', 'de') var locale = 'en'
export(Array, String) var resolutions = ['1280x720', '1920x1080', '1920x1200']
export(int) var resolution_selected = 0
export(bool) var fullscreen = false

