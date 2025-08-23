extends Node

const E: float = 2.718282

var rng: RandomNumberGenerator

# Set up random
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = int(10003 * (Time.get_ticks_usec() - int(Time.get_ticks_usec())))

# Sample from a normal distribution with a known value
func normal_dist(x: float, mean: float, sig: float) -> float:
	var diff = (x - mean)
	return exp(-1.0 * diff * diff / (2.0 * sig * sig))

func range_to_nums(start: float, end: float, interval: float) -> int:
	return int(abs(end - start) / interval)

func vec3_from_vec4(v4: Vector4) -> Vector3:
	return Vector3(v4.x, v4.y, v4.z)

func average(vals: Array) -> float:
	var total = 0.0
	var amt = 0.0
	for i in vals:
		total += i
		amt += 1.0
	return total / amt

# True returns 1, False returns -1
func bool_to_unit(b: bool) -> int:
	return (2 * int(b)) - 1

# Actually a random sampling of a normal distribution approximating a binomial
# No, I didn't check if this was a valid approximation. Fuck stats
func binomial_dist(mean: float, sig2: float) -> int:
	return int(rng.randfn(mean, sig2))
