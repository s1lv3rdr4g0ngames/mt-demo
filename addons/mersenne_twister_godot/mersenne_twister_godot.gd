@tool
extends Node
class_name MersenneTwister

## A GDScript implementation of Mersenne Twister
# some code stolen from https://github.com/yinengy/Mersenne-Twister-in-Python/blob/master/MT19937.py
# and the wikipedia article

# this gets closed in 4.7 but using this for now  https://github.com/godotengine/godot/pull/115649 
const UINT32_MAX :int= Vector3i.MAX.x - Vector3i.MIN.x

const n = 624
const m = 397
const w = 32
const r = 31
const u :int = 11
const s :int = 7
const t :int = 15
const l :int = 18
const f :int = 1812433253 # line 23 from Knuth 2nd ed, vol 2, page 102

const UPPER_MASK :int= 0x80000000
const LOWER_MASK :int= 0x7fffffff
const a :int = 0x9908b0df
const b :int = 0x9d2c5680
const c :int = 0xefc60000
const d : int = 0xffffffff

var mt_state_array : PackedInt32Array = PackedInt32Array(range(n))
var mt_state_index : int = 0
var _extract_index : int = 0

func _ready() -> void:
	mt_seed(19937)

# init the array
func mt_seed(seeed : int):
	_extract_index = n
	mt_state_array[0] = seeed
	for i in range(1, n):
		#1812433253 * (current index xor ((current index shifted right 30 times) + index
		var temp = f * (mt_state_array[i-1] ^ (mt_state_array[i-1] >> (w-2))) + i
		# AND with max int
		mt_state_array[i] = temp & d

# Extract a tempered value based on MT[index]
# calling twist() every n numbers
func extract_number() -> int:
	if _extract_index >= n:
		twist()
		_extract_index = 0
	
	var y:int = mt_state_array[_extract_index]
	# Tempering
	y = y ^ ((y >> u))# & d) omitted because it's redundant in 32 bit
	y = y ^ ((y << s) & b)
	y = y ^ ((y << t) & c)
	y = y ^ (y >> l)

	_extract_index += 1
	return y #& d

# Generate the next n values from the series x_i
func twist():
	for i in range(n):
		var x = (mt_state_array[i] & UPPER_MASK) + (mt_state_array[(i+1) % n] & LOWER_MASK)
		var xA = x >> 1
		if (x % 2) != 0:
			xA = xA ^ a
		mt_state_array[i] = mt_state_array[(i + m) % n] ^ xA

#region Rand Functions

# I think this works and doesn't lose precision? 
# and I think uint32_max is defined right?
func mt_randf() -> float:
	return float(extract_number()) / float(UINT32_MAX)

# Stolen from the godot source code
func mt_randf_range(p_from: float, p_to: float) -> float:
	return mt_randf() * (p_to - p_from) + p_from

# godot randi returns a 32 bit unsigned int, which then immediately becomes a 64 bit signed
# so guess I'm doing that too
func mt_randi(val : int = 0) -> int:
	if val == 0:
		return extract_number()
	else:
		return extract_number() % val

func mt_randi_range(p_from:int, p_to:int) -> int:
	if (p_from == p_to):
		return p_from

	var _min := mini(p_from, p_to);
	var _max := maxi(p_from, p_to);
	var diff := _max - _min

	if (diff >= UINT32_MAX):
		# Even though godot int is 64 bit, the rand is not, so clamping it
		return mt_randi() + _min

	return (mt_randi(diff + 1)) + _min


#endregion
