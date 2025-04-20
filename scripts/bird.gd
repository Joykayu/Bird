extends CharacterBody2D


var max_velocity := 800


var dash_duration := 0.3
var dash_speed := max_velocity * 2
var is_dashing := false
var dash_timer = 0
var is_dash_cooling_down := false
var dash_cooldown_duration := 2

# Variables for player movement - Change to change the feel
var speed := 200



var speed_turning := 200

var rot_speed := 4.0
var rot_drag := 3.0

var drag := 1.0




var zoomout := 0.8
var zoomout_speed := 5.0

var angular_velocity := 0.0
var input_lag := 0.0
var counting_lag := false

var turning_left: bool = false
var turning_right: bool = false


func _ready()->void:

	$DashCD.wait_time = dash_cooldown_duration

func _physics_process(delta):
	
	if is_dashing:
		# incrpeent time in dash
		dash_timer += delta
		# check if dash is finished
		if dash_timer > dash_duration:
			is_dashing = false
			dash_timer = 0
			velocity = -(transform.y).normalized() * max_velocity
			# start cd
			$DashCD.start()
			
		else:
			# if not finished, set speed to dash speed
			velocity = -(transform.y).normalized() * dash_speed
	
	if counting_lag :
		input_lag += delta

	if input_lag > 0.05:
		
		if Input.is_action_pressed("flap_left") and Input.is_action_pressed("flap_right"):
			increment_velocity(speed)
			pass
			
		elif Input.is_action_pressed("flap_left") or Input.is_action_pressed("flap_right"):
			increment_velocity(speed_turning) 
			
			var rotation_direction = int(Input.is_action_pressed("flap_right")) - int(Input.is_action_pressed("flap_left"))
			angular_velocity = rotation_direction * rot_speed
		
		counting_lag = false
		input_lag = 0
		Input.action_release("flap_left")
		Input.action_release("flap_right")
	
	
	angular_velocity = lerp(angular_velocity, 0.0, delta * rot_drag)
	rotation += angular_velocity * delta
	
	# set drag 
	velocity = -(transform.y).normalized() * velocity.length()
	velocity = lerp(velocity, Vector2.ZERO, delta * drag)
	
	var target_zoom = Vector2.ONE * clampf(((zoomout-1)/max_velocity * velocity.length() + 1),zoomout,1.0)
	$Camera2D.zoom = lerp($Camera2D.zoom, target_zoom, zoomout_speed * delta)
	
	if self.velocity.length() > 0 :
		move_and_slide()


func _input(event):	
	
	if is_dashing:
		return
	
	if event is InputEventKey:
		if event.is_action_pressed("keyboard_left"):
			Input.action_press("flap_left")
			counting_lag = true
		if event.is_action_pressed("keyboard_right"):
			Input.action_press("flap_right")
			counting_lag = true
		if event.is_action_pressed("keyboard_dash"):
			if !$DashCD.is_stopped():
				return
			
			counting_lag = true
			is_dashing = true
			dash_timer = 0
			
			
func increment_velocity (increment: float):
	var new_velocity_length = velocity.length() + increment
	
	if new_velocity_length > max_velocity:
		velocity = - transform.y.normalized() * max_velocity
		return
	
	velocity = - transform.y.normalized() * new_velocity_length
	
	#
