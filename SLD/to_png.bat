@echo off
echo Punt

setlocal EnableDelayedExpansion

echo circle
REM FORFILES /p .\svg /m pc*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m pc*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo driehoek
REM FORFILES /p .\svg /m pd*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m pd*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo kruis
REM FORFILES /p .\svg /m pk*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m pk*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo ruit
FORFILES /p .\svg /m pr*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
FORFILES /p .\svg /m pr*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo ster
REM FORFILES /p .\svg /m ps*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m ps*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo vierkant
REM FORFILES /p .\svg /m pv*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m pv*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

echo X
REM FORFILES /p .\svg /m px*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 288 -y 0 -o %~dp0png_hoog\\@fname.png |echo @file hoog"
REM FORFILES /p .\svg /m px*.svg /C "cmd /c C:\Progra~1\Inkscape\bin\inkscape.com @file -d 96 -y 0 -o %~dp0png_laag\\@fname.png |echo @file laag"

