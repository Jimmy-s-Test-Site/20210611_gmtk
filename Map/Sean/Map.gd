extends Node2D

signal level_complete

export(NodePath) var player
export(NodePath) var car_container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for car in self.get_node(self.car_container).get_children():
		car.get_node("GPS/Car").connect("clicked_on", self, "on_car_clicked")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ungrapple"):
		for spring in $SpringContainer.get_children():
			spring.queue_free()

func on_car_clicked(car : RigidBody2D) -> void:
	self.get_node(self.player).car_clicked = car
	
	for spring in $SpringContainer.get_children():
		spring.queue_free()
	
	var node := DampedSpringJoint2D.new()
	node.node_a = self.get_node(self.player).get_path()
	node.node_b = car.get_path()
	node.length = 8
	node.rest_length = 5
	$SpringContainer.add_child(node)
