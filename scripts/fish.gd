extends Collectible


@export var turning : bool = true
@export var freq := 0.20
@export var x_offset := 0.0
@export var y_offset := 0.0

@onready var start_pos : Vector2 = self.position
@onready var positions: = [self.global_position]

var time := randf() * 2 * PI


func _physics_process(delta):
	
	if positions.size()>2:
		positions.pop_front()
	positions.append(self.global_position)
	var an = (positions[-1]-positions[0]).angle()
	self.global_rotation = an + PI/2

	time += delta
	if turning:
		self.position = start_pos + Vector2(x_offset * cos(2 * PI * freq * time), y_offset * sin(2 * PI * freq * time))
