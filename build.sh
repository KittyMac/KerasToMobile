#!/bin/sh

# Simple script for a one-stop-shop to convert a trained keras .h5 model to .tflite and .mlmodel on mac os x
# Note: since this only does model conversion and no training, we don't care about GPU accelerated tensorflow

unamestr=`uname`

priv_virtualenv() {
	
	if [ $unamestr = "Linux" ]
	then
		sudo apt install -y python3-pip
	else
		brew install python3
	fi
	
	# create the virtualenv if it does not exist
	if [ ! -d "modelConverter.env" ]; then
		pip3 install --upgrade pip
		pip3 install virtualenv
		virtualenv -p python3 modelConverter.env
	fi
	
	# '.' command is the same as 'source'
	. ./modelConverter.env/bin/activate
}

priv_install_linux () {
	echo "TBD"
}

priv_install_mac () {
	echo "TBD"
}

priv_install () {
	
	priv_virtualenv
	
	if [ $unamestr = "Linux" ]
	then
		priv_install_linux
	else
		priv_install_mac
	fi
	
	# install other dependencies
	pip3 install h5py
	pip install keras
	pip install tensorflow
}


priv_convert_tflite () {
	tflite_convert --output_file=$2 --keras_model_file=$1
}

priv_convert_mlmodel () {
	echo "TBD"
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
