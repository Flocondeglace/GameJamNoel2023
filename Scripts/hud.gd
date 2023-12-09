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

var bar
var textbonhomme
var pointlabel
var combolabel
var fps
var commentsContainer

func _ready():
	# IN Game
	bar = $GameLayer/AssassinationBar
	textbonhomme = $GameLayer/TextBonhomme
	pointlabel = $GameLayer/Container/Point
	combolabel = $GameLayer/Container/Combo
	commentsContainer = $GameLayer/Comments
	
	# FPS
	fps = $FPS/FPS_COUNTER
	
	# Manager
	gm = get_parent().get_node("GameManager")
	am = get_parent().get_node("AudioManager")
	
	# LAYER
	gmLayer = gm.get_node("CanvasLayer")
	tabScoreLayer = get_node("TabScoreLayer")
	menuLayer = get_node("MenuLayer")
	pauseLayer = get_node("PauseLayer")
	choosePartitionLayer = get_node("ChoosePartitionLayer")
	
	# ScoreTab
	tabScoreContainer = tabScoreLayer.get_node("CenterContainer/PanelContainer/VBoxContainer/tabScoreContainer")
	
	# Cacher les layers
	gmLayer.hide()
	tabScoreLayer.hide()
	pauseLayer.hide()
	choosePartitionLayer.hide()
	
	# Afficher le menu
	menuLayer.show()
	
	# Select un boutton par default
	(get_tree().get_nodes_in_group("buttonMenu"))[0].grab_focus()


#func _process(delta):
#	fps.text = str(Engine.get_frames_per_second()) 


func update_score(score,combo):
	combolabel.text = "x" + "[b]" + str(combo) + "[/b]"
	pointlabel.text = "score : " + str(score)
	bar.value = score
	if bar.value == bar.max_value :
		textbonhomme.text = "I'm dead..."
	elif bar.value > bar.max_value/2 :
		textbonhomme.text = "Your killing me ! STOP !"
	

# Afficher le commentaire un court instant
func add_comment(texte):
	var comment = comment_template.instantiate()
	commentsContainer.add_child(comment)
	comment.text = texte
	comment.visible_ratio = 1
	await get_tree().create_timer(0.5).timeout
	comment.queue_free()
	

func print_liste_score(tabScore):
	gmLayer.hide()
	tabScoreLayer.show()
	
	for child in tabScoreContainer.get_children():
		child.queue_free()
		
	for i in range(0,tabScore.size()):
		var score_i_nom = score_item_template.instantiate()
		score_i_nom.text = "[left]" + tabScore[i][0] + "[/left]"
		var score_i_ch = score_item_template.instantiate()
		score_i_ch.text =  "[right]" + str(tabScore[i][1]) + "[/right]"
		tabScoreContainer.add_child(score_i_nom)
		tabScoreContainer.add_child(score_i_ch)



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
	(get_tree().get_nodes_in_group("buttonPause"))[1].grab_focus()


func _on_replay_pressed():
	gm.init_lancement_partie(level)
	tabScoreLayer.hide()
	pauseLayer.hide()
	gmLayer.show()



func choose_partition():
	am.activate_choose_level(true)
	choosePartitionLayer.show()
	gm.init_data()
	gm.continue_game()
	(get_tree().get_nodes_in_group("level"))[0].grab_focus()
	await levelchoosed
	choosePartitionLayer.hide()
	am.activate_choose_level(false)



func _on_button_play_pressed():
	await choose_partition()
	gm.init_lancement_partie(level)
	menuLayer.hide()
	gmLayer.show()


func _on_button_quit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	pauseLayer.hide()
	gm.pause_legal = true
	gm.continue_game()
	gmLayer.show()

func _on_levelchoosed(l):
	level = l
	print("level choosed "+str(l))
	emit_signal("levelchoosed")


func _on_pause_layer_changelevel():
	pauseLayer.hide()
	push_warning("pause change level")
	await choose_partition()
	_on_replay_pressed()


func _on_back_to_menu_pressed():
	tabScoreLayer.hide()
	menuLayer.show()
	(get_tree().get_nodes_in_group("buttonMenu"))[0].grab_focus()
