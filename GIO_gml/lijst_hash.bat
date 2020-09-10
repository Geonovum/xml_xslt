@echo off

setlocal EnableDelayedExpansion
echo Files SHA512 > SHA512_log.txt
for /r %%i in (*.gml) do (
  for /f "tokens=*" %%j in ('dir /b /s "%%i"') do (
    certutil -hashfile "%%j" SHA512 | find /i /v "certutil" >> SHA512_log.txt
    )
  )
endlocal