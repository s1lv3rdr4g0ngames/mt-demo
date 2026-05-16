extends Control

var histogram : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(20):
		histogram.append(0)

func generate(rolls :int):
	var tim = Time.get_ticks_usec()
	for i in rolls:
		var n = MTRand.mt_randi_range(1, 20)
		histogram[n-1] += 1
	
	var num = 1
	for i in histogram:
		$Label.text += "%d: %d, %0.3f%%\n" % [num, i, float(i)/float(rolls)*100]
		num += 1
	
	$Label.text += "\nTime to complete: " + str(float(Time.get_ticks_usec() - tim) / float(1000000)) + " sec"


func _on_button_button_up() -> void:
	generate(10)

func _on_button_2_button_up() -> void:
	generate(10000)

func _on_button_3_button_up() -> void:
	generate(10000000)
