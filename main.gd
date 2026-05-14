extends Control

var histogram : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(20):
		histogram.append(0)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate():
	var tim = Time.get_ticks_usec()
	for i in 10000000:
		var n = MTGD.mt_randi_range(1, 20)
		histogram[n-1] += 1
	
	var num = 1
	for i in histogram:
		$Label.text += "%d: %d, %3f%%\n" % [num, i, float(i)/float(100000)]
		num += 1
	
	$Label.text += "\nTime to complete: " + str(float(Time.get_ticks_usec() - tim) / float(1000000))


func _on_button_button_up() -> void:
	generate()
