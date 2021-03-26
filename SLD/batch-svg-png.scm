(define (batch-svg-png Resolution
                              Width
                              Height)
  (let* ((filelist (cadr (file-glob "*.svg" 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (file-svg-load RUN-NONINTERACTIVE filename filename Resolution Width Height 0)))
                  (drawable (car (gimp-image-get-active-layer image)))
				  (newfile (string-append (string-append filename (number->string Resolution)) "_.png")))
				(gimp-image-convert-indexed image CONVERT-DITHER-NONE CONVERT-PALETTE-GENERATE 2 FALSE TRUE "")
				(set! drawable(car(gimp-image-get-active-layer image)))
				(file-png-save RUN-NONINTERACTIVE image drawable newfile newfile 0 0 1 0 0 1 1)
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))
(script-fu-register
  "batch-svg-png"               ;func name
  "Batch Convert By Factor"                   ;menu label
  "converts svg to png removes AA"  ;description
  "Bert Verhees"                          ;author
  ""
  "2021-03-26"                              ;date created
  ""                                        ;image type that the script works on
  SF-VALUE "Resolution" "96"
  SF-VALUE "Width" "24"
  SF-VALUE "Height" "24"
)
