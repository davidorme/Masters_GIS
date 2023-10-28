#!/usr/bin/env bash

# Switch between building all lecture or just named lectures
if [ $# -eq 0 ]; 
	then
		lectures="lecture_*"
	else
		lectures="$@" 
fi

for src in $lectures; do 
	
	echo $src
	
	src_md="${src}_marp.md"
	src_rmd="${src}_marp.rmd"

	# Knit RMD files
	if [ -f $src/$src_rmd ]; then
		# Knit in the source directory to avoid merging cache and figure directories
		cd $src
		echo " - Knitting RMD"; 
		Rscript -e "knitr::knit('$src_rmd', output='$src_md', quiet=TRUE)"
		cd ../
	fi
	

	# Build PDF and html
	echo " - Printing MD to PDF"; 
	npx @marp-team/marp-cli@latest $src/$src_md \
		--theme gaia_local.css \
		--allow-local-files --html --output pdfs/${src}.pdf
	
	echo " - Printing MD to HTML"; 
	npx @marp-team/marp-cli@latest $src/$src_md \
		--theme gaia_local.css \
		--allow-local-files --html --output $src/${src}.html
	
done
