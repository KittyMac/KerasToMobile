#!/bin/sh

# Simple script for a one-stop-shop to convert a trained keras .h5 model to .tflite and .mlmodel on mac os x
# Note: since this only does model conversion and no training, we don't care about GPU accelerated tensorflow

unamestr=`uname`

priv_virtualenv() {
	
	# Note: we're using python 3.5 because coreml tools doesn't work with 3.7 yet...
	
	# https://github.com/sashkab/homebrew-python
	brew install sashkab/python/python35
	
	# create the virtualenv if it does not exist
	if [ ! -d "modelConverter.env" ]; then
		pip3 install --upgrade pip
		pip3 install virtualenv
		virtualenv -p python3.5 modelConverter.env
	fi
	
	# '.' command is the same as 'source'
	. ./modelConverter.env/bin/activate
}

priv_install () {
	priv_virtualenv
		
	# install other dependencies
	pip3 install h5py
	pip3 install keras
	pip3 install tensorflow
	pip3 install -U coremltools
}


priv_convert_tflite () {
	tflite_convert --output_file=$2 --keras_model_file=$1
}

priv_convert_mlmodel () {
	python coreml.py $1 $2
}

priv_convert () {
	priv_virtualenv
	
	INPUT_FILE=$1
	OUTPUT_TFLITE_FILE="${1%.*}.tflite"
	OUTPUT_MLMODEL_FILE="${1%.*}.mlmodel"
	
	priv_convert_tflite $INPUT_FILE $OUTPUT_TFLITE_FILE
	priv_convert_mlmodel $INPUT_FILE $OUTPUT_MLMODEL_FILE
}


if [ $1 = "install" ]
then
	priv_install
	exit 0
fi

if [ $1 = "convert" ]
then
	priv_convert $2
	exit 0
fi


echo "usage: ./build.sh [command] [arguments]"
echo "	install - install all of the necessary dependencies and create virtualenv"
echo "	convert - convert the supplied keras .h5 model to tflite and coreml"
