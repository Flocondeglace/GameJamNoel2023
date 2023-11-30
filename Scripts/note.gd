extends TextureRect

var pos_objectif
var pos_depart
var temps_descente = 1
var timer_descente
var temps_fin = 0
var speed
var num_touche
var x
var immobile
var gameManager
var ligney
var point

# Pour les effets
var texture_light = preload("res://Images/2d_lights_and_shadows_neutral_point_light.webp")

func _ready():
	gameManager = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var yecran = get_window().size.y
	#push_warning(str(yecran) +" liney : " + str(ligney))
	if (num_touche!=null && !immobile):
		set_position(position.move_toward(Vector2(x,ligney+228),speed*delta))
		if (position == Vector2(x,ligney + 228)):
			gameManager.reset_combo()
			#push_warning("trop loin")
			queue_free()
	
func apparition(num:int=0,liney:int=788,couleur:Color=Color.LIGHT_CORAL,pt:int=1):
	point = pt
	modulate = couleur
	ligney=liney
	immobile = false;
	#Timer
	timer_descente = Timer.new()
	timer_descente.set_one_shot(true)
	timer_descente.connect("timeout",_on_timer_timeout)
	add_child(timer_descente)
	#push_warning(timer_descente)
	temps_fin = 0
	temps_descente = 1
	num_touche = num
	x = 500 + num_touche * 300
	pos_depart = Vector2(x,0)
	set_position(pos_depart)
	pos_objectif = Vector2(x,liney)#-(128/2))
	#pos_objectif = Vector2(x,788)
	speed = (pos_objectif - pos_depart).length()
	timer_descente.set_autostart(true)

func get_num_touche():
	return num_touche

func get_temps_ecart():
	var tleft = timer_descente.get_time_left()
	var temps_ecart
	if (tleft == 0):
		temps_ecart = (float(Time.get_ticks_msec()) - float(temps_fin))/1000
	else :
		temps_ecart = (tleft)  
	#push_warning("temps ecart : " + str(temps_ecart) + "tleft : " + str(tleft))
	return temps_ecart

# Parametre : bool, valide -> true si la note a bien été appuyée dans les clous
func attrape(valide:bool):
	
	var effect_time = Timer.new()
	add_child(effect_time)
	effect_time.start(0.1)
	
	# Effet de stop
	immobile = true
	
	# Effet de grossissement
	var ptaille = get_size()
	var taille = get_size()*1.1
	set_size(taille)
	var xdec = (taille.x/2) - (ptaille.x/2)
	var ydec = (taille.y/2) - (ptaille.y/2)
	set_position(get_position() - Vector2(xdec,ydec))
	
	var lum
	if valide :
		# Effet de lumière
		lum = PointLight2D.new()
		lum.set_texture(texture_light)
		lum.set_texture_offset(get_position())
		lum.set_texture_scale(10)
		add_child(lum)
	

	await effect_time.timeout
	#push_warning("timeout")
	if valide:
		lum.queue_free()
	queue_free() 

func get_point():
	return point

func _on_timer_timeout():
	temps_fin = float(Time.get_ticks_msec())

