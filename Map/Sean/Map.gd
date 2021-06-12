extends Node2D

signal level_complete
var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	for car in $cars.get_children() :
		car.connect("clicked_on", self, "car_Clicked",[car])
		pass
	pass 	# Replace with function body.

func car_Clicked(car):
	player.car_clicked = car
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

