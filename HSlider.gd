extends HSlider

@export var audio_bus_master: String
@export var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Saving the access point for the audio bus
	bus_index = AudioServer.get_bus_index(audio_bus_master)
	
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Changing Volume
func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
