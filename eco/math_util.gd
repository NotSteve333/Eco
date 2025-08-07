extends Resource

const E: float = 2.718282

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
