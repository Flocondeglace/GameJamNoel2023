extends CanvasLayer

signal continu
signal replay
signal changelevel


func _on_replay_pressed():
	replay.emit()


func _on_continue_pressed():
	continu.emit()
 


func _on_change_level_pressed():
	changelevel.emit()


func _on_quit_pressed():
	get_tree().quit()
