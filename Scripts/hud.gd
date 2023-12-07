extends CanvasLayer

signal levelchoosed
var level

var score_item_template = preload("res://Scenes/score_item.tscn")
var boite_nom_template = preload("res://Scenes/question_nom.tscn")
var validate_template = preload("res://Scenes/validate.tscn")
var pop_up_template = preload("res://Scenes/pop_up.tscn")
var clavier_template = preload("res://Scenes/clavier.tscn")
var comment_template = preload("res://Scenes/comment.tscn")

var tabScoreLayer
var menuLayer
var pauseLayer
var choosePartitionLayer
var tabScoreContainer

var gm # GameManager
var gmLayer # Layer du GameManager
var am # AudioManager


func _ready():
	gm = get_parent().get_node("GameManager")
	gmLayer = gm.get_node("CanvasLayer")
	gmLayer.hide()
	am = get_parent().get_node("AudioManager")
	tabScoreLayer = get_node("TabScoreLayer")
	tabScoreContainer = get_node("TabScoreLayer/CenterContainer/VBoxContainer/tabScoreContainer")
	tabScoreLayer.hide()
	menuLayer = get_node("MenuLayer")
	menuLayer.show()
	pauseLayer = get_node("PauseLayer")
	pauseLayer.hide()
	choosePartitionLayer = get_node("ChoosePartitionLayer")
	choosePartitionLayer.hide()
	(get_tree().get_nodes_in_group("buttonMenu"))[0].grab_focus()
	#tabScoreContainer.hide()
	#var titre = menuLayer.get_node("CenterContainer/MarginContainer/VBoxContainer/Titre")
	#oscillo(titre)

func _process(delta):
	$FPS/FPS_COUNTER.text = str(Engine.get_frames_per_second()) 

func update_score(score,combo):
	$Container/Combo.text = "x" + "[b]" + str(combo) + "[/b]"
	$Container/Point.text = "score : " + str(score)

func add_comment(texte):
	var comment = comment_template.instantiate()
	$Comments.add_child(comment)
	
	comment.text = texte
	# Effet
	comment.visible_ratio = 1
	await get_tree().create_timer(0.5).timeout
	#await appear(comment)
	#await disappear(comment)
	comment.queue_free()
	

func print_liste_score(tabScore):
	gmLayer.hide()
	tabScoreLayer.show()
	#var tabScoreContainer = get_node("CenterContainer/tabScoreContainer")
	for child in tabScoreContainer.get_children():
		child.queue_free()
	# faire un tableau pour les rangers
	for i in range(0,tabScore.size()):
		var score_i_nom = score_item_template.instantiate()
		score_i_nom.text = "[left]" + tabScore[i][0] + "[/left]"
		var score_i_ch = score_item_template.instantiate()
		score_i_ch.text =  "[right]" + str(tabScore[i][1]) + "[/right]"
		tabScoreContainer.add_child(score_i_nom)
		tabScoreContainer.add_child(score_i_ch)
	#tabScoreContainer.show()


func ask_for_name():
	var pop_up = pop_up_template.instantiate()
	print("nom demandé")
	
	$First.add_child(pop_up)
	pop_up.show()
	var boite_question = $First.get_node("PopUp/Margin/VBoxContainer/HBoxContainer/question_nom")
	var validate = $First.get_node("PopUp/Margin/VBoxContainer/HBoxContainer/Validate")
	validate.grab_focus()
	await validate.pressed
	(get_tree().get_nodes_in_group("button"))[0].grab_focus()
	var question = boite_question.text
	$First.remove_child(pop_up)
	return question

func activate_pause_menu():
	pauseLayer.show()
	(get_tree().get_nodes_in_group("buttonPause"))[0].grab_focus()
	#gmLayer.hide()
	
#func disappear(objet):
#	var t = Timer.new()
#	add_child(t)
#
#	while (objet.visible_ratio > 0):
#		t.start(0.005)
#		objet.visible_ratio = max(0, objet.visible_ratio - 0.2)
#		await t.timeout
#	t.queue_free()

#func appear(objet):
#	var t = Timer.new()
#	add_child(t)
#	objet.visible_ratio = 1
#	t.start(0.4)
#	await t.timeout
#	t.queue_free()
	

func _on_replay_pressed():
	gm.init_data()
	tabScoreLayer.hide()
	pauseLayer.hide()
	gm.continue_game()
	#am.activer_transition()
	gm.debut_partition(level)
	
	am.effacer(2)
	gmLayer.show()

func choose_partition():
	choosePartitionLayer.show()
	gm.init_data()
	gm.continue_game()
	
	(get_tree().get_nodes_in_group("level"))[0].grab_focus()
	await levelchoosed
	choosePartitionLayer.hide()
	

func _on_button_play_pressed():
	gm.pause_legal = false
	await choose_partition()
	menuLayer.hide()
	gm.debut_partition(level)
	gmLayer.show()


func _on_button_quit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	pauseLayer.hide()
	gm.continue_game()
	gmLayer.show()

func _on_levelchoosed(l):
	level = l
	print("level choosed "+str(l))
	emit_signal("levelchoosed")


func _on_pause_layer_changelevel():
	pauseLayer.hide()
	
	#gm.continue_game()
	push_warning("pause change level")
	await choose_partition()
	_on_replay_pressed()
	#push_warning("a choisi")
	#gm.debut_partition(level)
	#_on_replay_pressed()
