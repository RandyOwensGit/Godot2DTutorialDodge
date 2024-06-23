extends HSlider

# Access audio buses by index not by name

@export var master_volume_bus: String

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find and assign the Master audio bus index
	bus_index = AudioServer.get_bus_index(master_volume_bus)
	
	#value_changed.connect(_on_value_changed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Update Master audio bus value
func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
