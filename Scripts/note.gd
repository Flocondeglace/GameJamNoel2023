extends TextureRect
class_name Note
var pos_objectif
var pos_depart
var temps_descente = 1
var temps_fin = 0
var speed
var num_touche
var x
var immobile
var gameManager
var ligney
var point
var tmp_avant_act
var timer_desc
var anim



func _ready():
	gameManager = get_parent()
	timer_desc = $Timer_descente
	anim = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!immobile && num_touche!=null):
		set_position(position.move_toward(Vector2(x,ligney+228),speed*delta))
		if (position == Vector2(x,ligney + 228)):
			gameManager.reset_combo()
			queue_free()
			
func _exit_tree():
	if get_tree().get_nodes_in_group("note").size()== 1 :
		gameManager.last_note.emit()
	

func creation(tmp:int,num:int=0,liney:int=788,couleur:Color=Color.LIGHT_CORAL,pt:int=1,_effet:bool=false):
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
	pos_objectif = Vector2(x,liney)
	tmp_avant_act = tmp
	speed = (pos_objectif - pos_depart).length()

func activer():
	#await get_tree().create_timer(tmp_avant_act,PROCESS_MODE_PAUSABLE).timeout
	immobile = false
	timer_desc.start()

func get_num_touche():
	return num_touche

func get_temps_ecart():
	var tleft = timer_desc.get_time_left()
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
		anim.play("growandglow")
		anim.play_backwards("growandglow")
	else :
		anim.play("grow")
	await get_tree().create_timer(0.2).timeout
	queue_free() 

func get_point():
	return point

func _on_timer_timeout():
	print("fin")
	temps_fin = float(Time.get_ticks_msec())



