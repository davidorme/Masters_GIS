#!/usr/bin/env bash

if [ $# -eq 0 ]; 
	then
		lectures="lecture_*"
	else
		lectures="$@" 
fi

for src in $lectures; do 
	
	echo $src
	
	# Knit RMD files
	if [ -f $src/$src.rmd ]; then
		# Knit in the source directory to avoid merging cache and figure directories
		cd $src
		echo " - Knitting RMD"; 
		Rscript -e "knitr::knit('$src.rmd', output='$src.md', quiet=TRUE)"
		cd ../
	fi
	
	# Print through reveal-md, using an alternative port in case the default is
	# already being used to view slides. Have to build from md here, because 
	# reveal-md only looks for the JSON configs in the calling directory.
	echo " - Printing MD"; 
	reveal-md $src/$src.md --css lectures.css --print slides/$src.pdf --port 1947

done