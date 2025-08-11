extends Resource

@onready var rng = RandomNumberGenerator.new()

const E: float = 2.718282

func _ready() -> void:
	rng.seed = int(10003 * (cur_time - int(cur_time)))

func normal_dist(x: float, mean: float, sig: float) -> float:
	var numer = -1.0 * pow((x - mean), 2)
	var denom = 2.0 * pow(sig, 2)
	var expo = numer / denom
	return pow(E, expo)

func average(vals: Array) -> float:
	var total = 0.0
	var amt = 0.0
	for i in vals:
		total += i
		amt += 1.0
	return total / amt

func bool_to_unit(b: bool) -> int:
	return (2 * int(b)) - 1

func binomial_dist(n: int, p: float) -> int:
	var mean = n * p
	var npq = mean * (1 - p)
	var stdev = sqrt(npq)
	return int(rng.randfn(mean, stdev))
