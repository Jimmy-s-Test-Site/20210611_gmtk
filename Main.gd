extends Node2D

export (Array, PackedScene) var levels

var currLevel = -1 

func _ready() -> void:
	loadNextLevel()
	pass # Replace with function body.
	

func loadNextLevel():
	if $currentLevel.get_child_count() == 1:
		$currentLevel.get_child(0).queue_free()
	currLevel = (currLevel + 1) % self.levels.size()
	$currentLevel.add_child(self.levels[currLevel])

func onLevelComplete():
	pass
	pass
	pass
	pass
