extends Tuple
class_name Triple

var mid_elem: Variant

func mid() -> Variant:
	return mid_elem

func _init(head: Variant, mid: Variant, tail: Variant):
	mid_elem = mid
	super(head, tail)

func purge_triple_array_tuples() -> void:
	var first = head()
	for t in first:
		t.done()
	var second = mid()
	for t in second:
		t.done()
	var third = tail()
	for t in third:
		t.done()
	
