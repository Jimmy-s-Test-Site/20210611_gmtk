extends RigidBody2D

# Player Movement 
# Skating
#	Horizontal: A, D
#	Acceleration: W, S
# Grappling
#	Grapple: LMB
#	Ungrapple: RMB

var car_clicked : RigidBody2D

enum {
	SKATE,
	ATTACH
}

# variables

export var skate_max_speed := 100.0
export var skate_speed := 200.0

export var grapple_max_speed := 20.0
export var grapple_max_distance := 200.0

onready var _transitions := {
	SKATE: [ATTACH],
	ATTACH: [SKATE]
}

var _state : int = SKATE
var input_grapple = false
var input = Vector2.ZERO


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	self.input_manager()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	self.do_state()
	self.leave_state(state)

func _physics_process(delta: float) -> void:
	if _state == SKATE:
		pass


func input_manager() -> void:
	self.input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("decelerate") - Input.get_action_strength("accelerate")
	).normalized()

func enter_state() -> void:
	match _state:
		SKATE:
			$DampedSpringJoint2D.node_b = null
		ATTACH:
			$DampedSpringJoint2D.node_b = self.car_clicked
		_:
			return

func do_state() -> void:
	match self._state:
		SKATE:
			#if self.linear_velocity.length() < self.skate_max_speed and is_equal_approx(self.linear_velocity.length(), self.skate_max_speed):
			#	pass
			
			print(self.input)
			
			if self.linear_velocity.length() <= self.skate_max_speed:
				self.apply_central_impulse(self.input * self.skate_speed)
			
			#self.apply_central_impulse(self.input * self.skate_speed)
			#
			#if self.linear_velocity.length() > self.skate_max_speed:
			#	self.linear_velocity = self.linear_velocity.normalized() * self.skate_max_speed
		ATTACH:
			pass

func leave_state(state: Physics2DDirectBodyState) -> void:
	match self._state:
		SKATE:
			# TODO: implement later :D
			if car_clicked != null:
				self.change_state(ATTACH)
		ATTACH:
			if Input.is_action_just_pressed("ungrapple"):
				self.change_state(SKATE)
			elif car_clicked != null:
				self.change_state(ATTACH)

func change_state(target_state : int) -> void:
	if not target_state in self._transitions[self._state]:
		return
	
	self._state = target_state
	self.enter_state()
