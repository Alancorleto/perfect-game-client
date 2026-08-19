class_name ListChartsResponse
extends Serializable

var charts: Array = []
var offset: int = 0
var size: int = 0
var total_count: int = 0

func _init(from_dict: Dictionary = {}) -> void:
	super(from_dict)

	charts.clear()
	for chart_dict: Dictionary in from_dict["charts"]:
		charts.append(ChartResponse.new(chart_dict))
