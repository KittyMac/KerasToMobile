from keras import backend as K

import coremltools
import sys


def export(inputPath, outputPath):
	coreml_model = coremltools.converters.keras.convert(inputPath)
	coreml_model.save(outputPath)

if __name__ == '__main__':
	
	if len(sys.argv) == 3:
		export(sys.argv[1], sys.argv[2])
	else:
		print("usage: <input path> <output path>")
	