extends Node

var defaults = [120, 120, 120]

func load_scores():
	var scores = []
	print(FileAccess.file_exists("user://records.bin"))
	if FileAccess.file_exists("user://records.bin"):
		var file = FileAccess.open_compressed("user://records.bin", FileAccess.READ, FileAccess.COMPRESSION_FASTLZ)
		
		if file == null:
			scores = [120, 120, 120]
			return
		
		file.seek(0)
		
		var score_number = file.get_16()
		
		for i in range(score_number):
			scores.append(file.get_float())
		
		file.close()
		
		return scores
	
	else:
		scores = [120, 120, 120]
		return scores

func save_score(level, score):
	print("Save score level %d: %d" % [level, round(score * 10) / 10])
	var scores = []
	var file = FileAccess.open_compressed("user://records.bin", FileAccess.READ, FileAccess.COMPRESSION_FASTLZ)
	
	if file == null:
		file = FileAccess.open_compressed("user://records.bin", FileAccess.WRITE, FileAccess.COMPRESSION_FASTLZ)
		file.store_16(3)
		
		for i in range(3):
			file.store_float(120)
		
		file.close()
		file = FileAccess.open_compressed("user://records.bin", FileAccess.READ, FileAccess.COMPRESSION_FASTLZ)
	
	file.seek(0)
	var score_number = file.get_16()
	
	for i in range(score_number):
		scores.append(file.get_float())
	
	if level >= score_number:
		scores.resize(level + 1)
		
		for i in range((level - score_number) + 1):
			scores[score_number + i] = 120
		
		score_number = len(scores)
	
	scores[level] = score
	
	file.close()
	file = FileAccess.open_compressed("user://records.bin", FileAccess.WRITE, FileAccess.COMPRESSION_FASTLZ)
	file.store_16(score_number)
	
	for i in scores:
		file.store_float(i)
	
	file.close()
