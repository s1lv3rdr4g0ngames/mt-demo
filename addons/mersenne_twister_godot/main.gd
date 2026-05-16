extends Control

var histogram : Array[int]
var histogram2 : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(19937)
	
	histogram.resize(20)
	histogram.fill(0)
	histogram2.resize(20)
	histogram2.append(0)

func generate(rolls :int, sequence : bool = false):
	var tim = Time.get_ticks_usec()
	if sequence == false:
		for i in rolls:
			var n = MTRand.mt_randi_range(1, 20)
			histogram[n-1] += 1
		
		var num = 1
		for i in histogram:
			$HBoxContainer/Label.text += "%d: %d, %0.3f%%\n" % [num, i, float(i)/float(rolls)*100]
			num += 1
		
		$HBoxContainer/Label.text += "\nTime to complete: " + str(float(Time.get_ticks_usec() - tim) / float(1000000)) + " sec"

	else:
		for i in rolls:
			var n = MTRand.mt_randi_range(1, 20)
			$HBoxContainer/Label.text += " %d," % n
	

func generate_default(rolls :int, sequence : bool = false):
	var tim = Time.get_ticks_usec()
	if sequence == false:
		for i in rolls:
			var n = randi_range(1, 20)
			histogram2[n-1] += 1
		
		var num = 1
		for i in histogram2:
			$HBoxContainer/Label2.text += "%d: %d, %0.3f%%\n" % [num, i, float(i)/float(rolls)*100]
			num += 1
			
		$HBoxContainer/Label2.text += "\nTime to complete: " + str(float(Time.get_ticks_usec() - tim) / float(1000000)) + " sec"

	else:
		for i in rolls:
			var n = MTRand.mt_randi_range(1, 20)
			$HBoxContainer/Label2.text += " %d," % n
	


func _on_button_button_up() -> void:
	generate(10, true)

func _on_button_2_button_up() -> void:
	generate(10000)

func _on_button_3_button_up() -> void:
	generate(10000000)
	
func _on_button_4_button_up() -> void:
	generate_default(10, true)

func _on_button_5_button_up() -> void:
	generate_default(10000)

func _on_button_6_button_up() -> void:
	generate_default(10000000)

func reset_hist():
	$HBoxContainer/Label.text = "MT random test\n"
	$HBoxContainer/Label2.text = "Default random (PCG)\n"
	histogram.fill(0)
	histogram2.fill(0)


func _on_button_7_button_up() -> void:
	reset_hist()
