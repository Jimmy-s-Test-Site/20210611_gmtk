extends RigidBody2D

# Player Movement 
# Skating
#	Horizontal: A, D
#	Acceleration: W, S
# Grappling
#	Grapple: LMB
#	Ungrapple: RMB

var car_clicked : RigidBody2D

enum STATE {
	SKATE,
	ATTACH
}

# variables

export var skate_friction = 2
export var skate_acceleration = 3000.0
export var skate_speed_max := 24.8 #400.0

export var grapple_speed_max := 20.0
export var grapple_distance_max := 200.0

onready var _transitions := {
	STATE.SKATE: [STATE.ATTACH],
	STATE.ATTACH: [STATE.SKATE]
}

var _state : int = STATE.SKATE
var input_grapple := false
var input := Vector2.ZERO


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	self.input_manager()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	self.do_state(state)
	self.leave_state(state)

func _physics_process(delta: float) -> void:	
	if _state == STATE.SKATE:
		pass

func input_manager() -> void:
	self.input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("decelerate") - Input.get_action_strength("accelerate")
	).normalized()

func enter_state() -> void:
	match _state:
		STATE.SKATE:
			$DampedSpringJoint2D.node_b = null
		STATE.ATTACH:
			$DampedSpringJoint2D.node_b = self.car_clicked
		_:
			return

func do_state(state) -> void:
	# target direction
	var target_direction := self.input.rotated(self.rotation)
	# friction
	state.linear_velocity = lerp(state.linear_velocity, Vector2.ZERO, self.skate_friction * state.step)
	
	match self._state:
		STATE.SKATE:
			# acceleration
			state.linear_velocity += target_direction * self.skate_acceleration * state.step
		STATE.ATTACH:
			pass
	
	# clamp
	state.linear_velocity = state.linear_velocity.clamped(self.skate_speed_max)

func leave_state(state: Physics2DDirectBodyState) -> void:
	match self._state:
		STATE.SKATE:
			# TODO: implement later :D
			if car_clicked != null:
				self.change_state(STATE.ATTACH)
		STATE.ATTACH:
			if Input.is_action_just_pressed("ungrapple"):
				self.change_state(STATE.SKATE)
			elif car_clicked != null:
				self.change_state(STATE.ATTACH)

func change_state(target_state : int) -> void:
	if not target_state in self._transitions[self._state]:
		return
	
	self._state = target_state
	self.enter_state()
