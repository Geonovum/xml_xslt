@echo off

set files=*.gml
echo %files%
echo ^<Files type=SHA512^> > SHA512_log.txt
setlocal EnableDelayedExpansion
for /r %%i in (%files%) do (
  for /f "tokens=*" %%j in ('dir /b /s "%%i"') do (
    echo ^<File type=SHA512^>>> SHA512_log.txt
    echo ^<Filename^>>> SHA512_log.txt
     certutil -hashfile "%%j" SHA512 | find /i /v "certutil" | find /i "sha512" >> SHA512_log.txt
    echo ^</Filename^>>> SHA512_log.txt
    echo ^<hash^>>> SHA512_log.txt
     certutil -hashfile "%%j" SHA512 | find /i /v "certutil" | find /i /v "sha512" >> SHA512_log.txt
    echo ^</hash^>>> SHA512_log.txt
    echo ^</File type=SHA512^>>> SHA512_log.txt
    )
  )
endlocal
echo ^</Files type=SHA512^> >> SHA512_log.txt
