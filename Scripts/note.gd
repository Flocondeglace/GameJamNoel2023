extends TextureRect
class_name Note
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
var tmp_avant_act



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
			
func _exit_tree():
	if get_tree().get_nodes_in_group("note").size()== 1 :
		gameManager.last_note.emit()
	
func apparition(num:int=0,liney:int=788,couleur:Color=Color.LIGHT_CORAL,pt:int=1):
	point = pt
	modulate = couleur
	ligney=liney
	immobile = false;
	#Timer
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
	$Timer_descente.set_autostart(true)

func creation(tmp:int,num:int=0,liney:int=788,couleur:Color=Color.LIGHT_CORAL,pt:int=1,effet:bool=false):
	point = pt
	modulate = couleur
	ligney=liney
	immobile = true;
	temps_fin = 0
	temps_descente = 1
	num_touche = num
	x = 500 + num_touche * 300
	pos_depart = Vector2(x,-150)
	set_position(pos_depart)
	pos_objectif = Vector2(x,liney)#-(128/2))
	#pos_objectif = Vector2(x,788)
	tmp_avant_act = tmp
	#print(tmp_avant_act)
	speed = (pos_objectif - pos_depart).length()

func activer():
	#print(tmp_avant_act)
	await get_tree().create_timer(tmp_avant_act).timeout
	#print("reel acti")
	immobile = false
	$Timer_descente.start()

func get_num_touche():
	return num_touche

func get_temps_ecart():
	var tleft = $Timer_descente.get_time_left()
	var temps_ecart
	if (tleft == 0):
		temps_ecart = (float(Time.get_ticks_msec()) - float(temps_fin))/1000
	else :
		temps_ecart = (tleft)  
	return temps_ecart

# Parametre : bool, valide -> true si la note a bien été appuyée dans les clous
func attrape(valide:bool):
	
	# Effet de stop
	immobile = true
	
	# Effet de grossissement et lumière
	if valide :
		$AnimationPlayer.play("growandglow")
		$AnimationPlayer.play_backwards("growandglow")
	else :
		$AnimationPlayer.play("grow")
	await get_tree().create_timer(0.2).timeout
	queue_free() 

func get_point():
	return point

func _on_timer_timeout():
	temps_fin = float(Time.get_ticks_msec())



