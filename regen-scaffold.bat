#!/bin/bash
# MODEL=$1
# if [ "$#" -ne 1 ]
# then
#	echo "Missing model to generate"
#	exit 1
# fi

# echo "Regenerating scaffold for model: " + $MODEL

scaffold -c -p db/schema.rb


