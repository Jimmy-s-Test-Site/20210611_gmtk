extends RigidBody2D

# Player Movement 
# Skating
#	Horizontal: A, D
#	Acceleration: W, S
# Grappling
#	Grapple: LMB
#	Ungrapple: RMB

signal consumed_FEL(new_total)

enum {
	SKATE,	
	ATTACH
}

# variables

export var skate_max_speed := 100.0

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
		Input.get_action_strength("accelerate")   - Input.get_action_strength("decelerate")
	).normalized()

func enter_state() -> void:
	match _state:
		SKATE:
			pass
		ATTACH:
			pass
		_:
			return

func do_state() -> void:
	match self._state:
		SKATE:
			pass
		ATTACH:
			var propel_direction := self.get_local_mouse_position().normalized()
			self.apply_central_impulse(propel_direction.rotated(self.rotation).rotated(PI) * self.propel_speed)
			
			if self.linear_velocity.length() > self.max_propel_speed:
				self.linear_velocity = self.linear_velocity.normalized() * self.max_propel_speed
			
			$FireExtinguisher.process_material.direction = Vector3(propel_direction.x, propel_direction.y, 0)

func leave_state(state: Physics2DDirectBodyState) -> void:
	var is_touching_surface := state.get_contact_count() > 0
	
	match self._state:
		SKATE:
			if self.input_propel and self.FEL_amount > 0:
				self.change_state(ATTACH)
		ATTACH:
			self.change_state(SKATE)

func change_state(target_state : int) -> void:
	if not target_state in self._transitions[self._state]:
		return
	
	self._state = target_state
	self.enter_state()
