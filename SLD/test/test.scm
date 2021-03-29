#!/usr/bin/env bash
 
/c/Program\ Files/GIMP\ 2/bin/gimp-console-2.10.exe -b '
		(
		 	let*
			(
			 	(
				 	filelist
					(
					 	cadr
						(
						 	file-glob "*.svg" 1
						)
					)
				)
			)
			(
			 	while
				(
				 	not
					(
					 	null? filelist
					)
				)
				(
				 	let*
					(
					 	(
						 	filename
							(
								car
								(
								 	filelist
								)
							)
							(
							 	image
								(
								 	car
									(
									 	gimp-file-load RUN-NONINTERACTIVE filename filename
									)
								)
							)




		)'  -b '
		(
                        gimp-quit 0
                )'
