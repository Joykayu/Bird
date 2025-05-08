extends CharacterBody2D


var max_velocity := 800
var is_deactivated := true

var dash_duration := 0.3
var dash_speed := max_velocity * 2
var is_dashing := false
var dash_timer = 0
var is_dash_cooling_down := false
var dash_cooldown_duration := 0.5

@export var dash_color : Color 

# Variables for player movement - Change to change the feel
var speed := 200
var speed_turning := 200
var rot_speed := 3.0
var rot_drag := 3.0
var drag := 1.0


# camera settings
@onready var min_zoomout : float = $Camera2D.zoom.x
var max_zoomout := 0.3
var zoomout_speed := 0.5
var zoomin_speed := 0.1


var angular_velocity := 0.0
var input_lag := 0.0
var counting_lag := false

var turning_left: bool = false
var turning_right: bool = false



func _ready()->void:
	$BodySprite.material.set_shader_parameter("line_color", dash_color)
	$GPUParticles2D.modulate = dash_color
	$DashCD.wait_time = dash_cooldown_duration


func _process(_delta):
	if is_dashing:
		$BodySprite.material.set_shader_parameter("active",true)
		$GPUParticles2D.emitting = true
	else :
		$BodySprite.material.set_shader_parameter("active",false)
		$GPUParticles2D.emitting = false
		

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
			# also cancel out angular velocity. Dash is always straight
			angular_velocity = 0
	
	if counting_lag :
		input_lag += delta

	if input_lag > 0.05:
		
		if Input.is_action_pressed("flap_left") and Input.is_action_pressed("flap_right"):
			increment_velocity(speed)
			angular_velocity = 0
			
		elif Input.is_action_pressed("flap_left") or Input.is_action_pressed("flap_right"):
			if Input.is_action_pressed("flap_left"):
				%Sounds/BirdFlap.play()
			if Input.is_action_pressed("flap_right"):
				%Sounds/BirdFlip.play() 
				
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
	
	
	
	# 0.6*max velocity so that it doesn't start zoomin directly
	var target_zoom = Vector2.ONE * clampf(((max_zoomout-1)/(0.6*max_velocity) * velocity.length() + min_zoomout),max_zoomout,1.0)
	
	# zoom-in
	if $Camera2D.zoom.length() < target_zoom.length():
		$Camera2D.zoom = lerp($Camera2D.zoom, target_zoom, zoomin_speed * delta)
	# zoom-out, but only if speed
	else:
		$Camera2D.zoom = lerp($Camera2D.zoom, target_zoom, zoomout_speed * delta)
	
	if self.velocity.length() > 0 :
		move_and_slide()


func _input(event):	
	
	if is_deactivated:
		return
	
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
			
			%Sounds/BirdDash.play()
			counting_lag = true
			is_dashing = true
			dash_timer = 0
	
	# detect flaps on touchscreen.
	if event is InputEventScreenTouch:
		# do not consider finger releast as a tap.
		if event.is_pressed():
			# left 
			if event.position[0] < get_window().content_scale_size[0]/2:
				Input.action_press("flap_left")
				counting_lag = true
			else:
				Input.action_press("flap_right")
				counting_lag = true
	
	# detect drag to trigger a dash
	if event is InputEventScreenDrag:
		# if y drag speed is slow (finger presses, but does not move too much)
		#if abs(event.screen_relative[1]) < 10:
			#if event.position[0] < get_window().content_scale_size[0]/2:
				#Input.action_press("flap_left")
				#counting_lag = true
			#else:
				#Input.action_press("flap_right")
				#counting_lag = true
		## if y drag speed is high, i.e. a swipe:
		if abs(event.screen_relative[1]) >= 10:
			print('GO!')
			# release first bc we don't want to flap if the wanted action was a dash.
			Input.action_release("flap_left")
			Input.action_release("flap_right")
			# do nothing is dash is on cooldown.
			if !$DashCD.is_stopped():
				return
			%Sounds/BirdDash.play()
			counting_lag = true
			is_dashing = true
			dash_timer = 0
	
func deactivate() -> void:
	# block controls
	is_deactivated = true
	
func activate() -> void:
	# restore controls
	is_deactivated = false
	
func increment_velocity (increment: float):
	var new_velocity_length = velocity.length() + increment
	
	if new_velocity_length > max_velocity:
		velocity = - transform.y.normalized() * max_velocity
		return
	
	velocity = - transform.y.normalized() * new_velocity_length
	
	#
