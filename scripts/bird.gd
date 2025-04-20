extends CharacterBody2D



# 
var start_y_positions := [0,0]
var current_y_positions := [0,0]

var is_dragging := [false, false]

var dash_threshold := 25
var is_dashing := false
var is_dash_cooling_down := false
var dash_cooldown_duration := 1 

# Variables for player movement - Change to change the feel
var speed := 200
var dash_speed := 400
var speed_turning := 50
var rot_speed := 4.5
var drag := 1.0
var rot_drag := 4.0 
var max_velocity := 550

var zoomout := 0.8
var zoomout_speed := 5.0

var angular_velocity := 0.0
var input_lag := 0.0
var counting_lag := false

var turning_left: bool = false
var turning_right: bool = false

func _physics_process(delta):
	#if Input.is_action_just_pressed("ui_left"):
		#%LeftButton.emit_signal("pressed")
	#if Input.is_action_just_pressed("ui_right"):
		#%RightButton.emit_signal("pressed")
	
	if counting_lag :
		input_lag += delta

	if input_lag > 0.05:
		
		for index in range(0, len(start_y_positions)) :
			if abs(current_y_positions[index] - start_y_positions[index]) > dash_threshold:
				is_dashing = true
				
		if is_dashing:
			velocity -= transform.y * dash_speed
			
		else:
			if Input.is_action_pressed("flap_left") and Input.is_action_pressed("flap_right"):
				velocity -= transform.y * speed
				
			elif Input.is_action_pressed("flap_left") or Input.is_action_pressed("flap_right"):
				velocity -= transform.y * speed_turning
				
			var rotation_direction = int(Input.is_action_pressed("flap_right")) - int(Input.is_action_pressed("flap_left"))
			angular_velocity = rotation_direction * rot_speed
		
		is_dashing = false
		counting_lag = false
		input_lag = 0
		Input.action_release("flap_left")
		Input.action_release("flap_right")
		
		start_y_positions = [0,0]
		current_y_positions = [0,0]
	

	
	velocity = lerp(velocity, Vector2.ZERO, delta * drag)
	angular_velocity = lerp(angular_velocity, 0.0, delta * rot_drag)
	rotation += angular_velocity * delta
	
	var target_zoom = Vector2.ONE * clampf(((zoomout-1)/max_velocity * velocity.length() + 1),zoomout,1.0)
	$Camera2D.zoom = lerp($Camera2D.zoom, target_zoom, zoomout_speed * delta)
	
	if self.velocity.length() > 0 :
		move_and_slide()


func _input(event):	
	# is it a screen touch? is it the beginning of it?
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if event.position.x < get_viewport_rect().get_center().x:
				Input.action_press("flap_left")
			else:
				Input.action_press("flap_right")
			
			# start counting lag
			counting_lag = true
	
	
	if event is InputEventScreenDrag:
		counting_lag = true
		if event.is_released(): 
			is_dragging[event.index] = false
			
		if !is_dragging[event.index]:
			# register start position		
			start_y_positions[event.index] = event.position.y
			is_dragging[event.index] = true
			
		# export current position for this touch/drag
		current_y_positions[event.index] =  event.position.y
		
	if event is InputEventKey:
		counting_lag = true
		if event.is_action_pressed("keyboard_left"):
			Input.action_press("flap_left")
		if event.is_action_pressed("keyboard_right"):
			Input.action_press("flap_right")
		if event.is_action_pressed("keyboard_dash"):
			is_dashing = true
