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
			queue_free()
	
func apparition(num:int=0,liney:int=788):
	ligney=liney
	immobile = false;
	#Timer
	timer_descente = Timer.new()
	timer_descente.set_one_shot(true)
	timer_descente.connect("timeout",_on_timer_timeout)
	add_child(timer_descente)
	push_warning(timer_descente)
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
	push_warning("temps ecart : " + str(temps_ecart) + "tleft : " + str(tleft))
	return temps_ecart

func attrape():
	var effect_time = Timer.new()
	add_child(effect_time)
	effect_time.start(0.01)
	
	# Effet de grossissement
	var ptaille = get_minimum_size()
	var taille = get_minimum_size()*1.1
	set_size(taille)
	var xdec = (taille.x/2) - (ptaille.x/2)
	var ydec = (taille.y/2) - (ptaille.y/2)
	set_position(position - Vector2(xdec,ydec))
	
	# Effet de stop
	immobile = true
	await effect_time.timeout
	queue_free() 

func _on_timer_timeout():
	temps_fin = float(Time.get_ticks_msec())
