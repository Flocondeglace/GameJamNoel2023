extends ColorRect

#var origin_size = Vector2(1920,1080)
#
#func _ready():
#	get_viewport().size = Vector2(1400,1300)
#
#func _process(delta):
#	var screen = DisplayServer.screen_get_size()
#	push_warning(str(get_viewport().size))
#	set_size(Vector2(screen.x, get_viewport().size.y/10))
#	set_position(Vector2(0,screen.y*0.8))
