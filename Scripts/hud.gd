extends CanvasLayer

var score_item_template = preload("res://Scenes/score_item.tscn")
var boite_nom_template = preload("res://Scenes/question_nom.tscn")
var validate_template = preload("res://Scenes/validate.tscn")
var pop_up_template = preload("res://Scenes/pop_up.tscn")

var tabScoreLayer
var menuLayer
var pauseLayer
var tabScoreContainer

var gm # GameManager


func _ready():
	gm = get_parent().get_node("GameManager")
	tabScoreLayer = get_node("TabScoreLayer")
	tabScoreContainer = get_node("TabScoreLayer/CenterContainer/VBoxContainer/tabScoreContainer")
	tabScoreLayer.hide()
	menuLayer = get_node("MenuLayer")
	menuLayer.show()
	pauseLayer = get_node("PauseLayer")
	pauseLayer.hide()
	(get_tree().get_nodes_in_group("buttonMenu"))[0].grab_focus()
	#tabScoreContainer.hide()


func update_score(score,combo):
	$Container/Combo.text = "x" + "[b]" + str(combo) + "[/b]"
	$Container/Point.text = "score : " + str(score)

func add_comment(texte):
	$Comment.text = texte

func print_liste_score(tabScore):
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
	
	#var cpop_up = pop_up.get_node("Margin")
	#var container = HBoxContainer.new()
	#pop_up.size = Vector2(300,300)
	#container.set_size(Vector2(600,300))
	#var boite_question = boite_nom_template.instantiate()
	#var validate = validate_template.instantiate()
	#container.add_child(boite_question)
	#container.add_child(validate)
	#validate.grab_focus()
	
	#cpop_up.add_child(container)
	$First.add_child(pop_up)
	
	pop_up.show()
	var boite_question = $First.get_node("PopUp/Margin/VBoxContainer/HBoxContainer/question_nom")
	var validate = $First.get_node("PopUp/Margin/VBoxContainer/HBoxContainer/Validate")
	validate.grab_focus()
	await validate.pressed
	(get_tree().get_nodes_in_group("button"))[0].grab_focus()
	var question = boite_question.text
	#container.remove_child(boite_question)
	#container.remove_child(validate)
	#cpop_up.remove_child(container)
	$First.remove_child(pop_up)
	return question

func activate_pause_menu():
	pauseLayer.show()
	(get_tree().get_nodes_in_group("buttonPause"))[0].grab_focus()
	

func _on_replay_pressed():
	tabScoreLayer.hide()
	pauseLayer.hide()
	
	gm.continue_game()
	gm.debut_partition()


func _on_button_play_pressed():
	menuLayer.hide()
	gm.debut_partition()


func _on_button_quit_pressed():
	get_tree().quit()


func _on_continue_pressed():
	pauseLayer.hide()
	gm.continue_game()
