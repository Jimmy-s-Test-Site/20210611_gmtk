extends RigidBody2D

signal clicked_on

export (int) var speed = 10
export (int) var acceleration = 5
export (int) var driving_ability = true

var lane

func movement_manager():
	pass

#func _process(delta):
	




func _ready():
	pass # Replace with function body.


func _on_Car_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("clicked_on")
