extends Node2D

export (Array, PackedScene) var levels

var curr_level = 0

func _ready() -> void:
	self.load_level(self.curr_level)

func load_next_level():
	self.curr_level = (self.curr_level + 1) % self.levels.size()
	self.load_level(curr_level)

func load_level(idx : int):
	if $currentLevel.get_child_count() == 1:
		$currentLevel.get_child(0).queue_free()
	
	var level : Node = self.levels[self.curr_level].instance()
	
	$currentLevel.add_child(level)

func onLevelComplete():
	pass
