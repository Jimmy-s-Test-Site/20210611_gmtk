extends RigidBody2D

signal clicked_on

onready var GPS = get_parent()
export (NodePath) var target
export (int) var car_speed = 5

var path = []

func _process(delta):
	var drive_distance = car_speed * delta
	move_along_path(drive_distance)


func _ready():
	_update_navigation_path(self.position, self.get_node(self.target).position)


func move_along_path(distance):
	var last_point = self.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			var here = self.position
			self.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			var there = self.position
			#dumb dumb time start
			self.rotation = here.angle_to_point(there) - PI/2
			#dumb dumb time begin
			return
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
		
	self.position = last_point
	set_process(false)


func _update_navigation_path(start_position, end_position):
	path = GPS.get_simple_path(start_position, end_position, true)
	path.remove(0)
	set_process(true)












#var path = []
#var path_node = 0
#onready var GPS = get_parent()
#export (NodePath) var target
#
#export (int) var speed = .01
#
#func _ready():
#	self.find_path(self.get_node(self.target).global_position)
#
#func find_path(target_position):
#	self.path = GPS.get_simple_path(global_position, target_position)
#	self.path_node = 0
#
#
#func _integrate_forces(state: Physics2DDirectBodyState) -> void:
#	if path_node < path.size():
#		var direction = (path[path_node] - global_position)
#		if direction.length() < 10 :
#			path_node += 1
#		else:
#			self.movement_manager(state, direction)
#	else:
#		state.sleeping = true
#
#
#func _physics_process(delta) -> void:
#	pass
#
#
#func movement_manager(state: Physics2DDirectBodyState, direction : Vector2) -> void:
#	#var temp = state.linear_velocity.length()
#	state.linear_velocity = -state.linear_velocity
#	state.add_central_force(direction)
#	state.linear_velocity = state.linear_velocity.clamped(.1)
func get_target():
	return self.get_node(self.target)

func _on_Car_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		emit_signal("clicked_on")


func _on_Timer_timeout():
	#if self.hasCollidedwithwall for longer than two seconds:
		#delete self
	$Timer.start(2)



func _on_Car_body_shape_entered(body_id, body, body_shape, local_shape):
	print(body.get_parent().name)
	if body.get_parent().name == "Target":
		self.queue_free()
