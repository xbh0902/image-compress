@echo off

rem sc config winmgmt start= auto
setlocal enabledelayedexpansion

set p=%~dp0
for /f "delims=" %%i in ('dir /a-d /s /b') do (
     if "%%~xi" == ".JPG" ren "%%~fsi" "%%~ni.jpg"
     if "%%~xi" == ".jpeg" ren "%%~fsi" "%%~ni.jpg"
     if "%%~Xi" == ".JPEG" ren "%%~fsi" "%%~ni.jpg"
)
regsvr32.exe /s /i %p%\lib\CxImageATL.dll

set parent_dir=%~dp1
for %%i in (dir %1) do set name=%%~nxi
set COMPRESS_DIR=%parent_dir%!name!-压缩副本
if exist %COMPRESS_DIR% (
     @echo off
) else (
     @echo off
     mkdir %COMPRESS_DIR%
)


echo 图片压缩后将被保存到"%COMPRESS_DIR%"

echo 开始批量压缩全部图片:

echo.

echo.

pause

echo.

echo.



(dir %1 /aa /b /s | findstr /e /c:"bmp") >tmp.txt

for /f "delims=" %%i in (tmp.txt) do (

    %p%\bin\CxImage.exe %%i %COMPRESS_DIR%\%%~ni.bmp 1 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.bmp

)

(dir %1 /aa /b /s | findstr /e /c:"gif") >tmp.txt

for /f "delims=" %%i in (tmp.txt) do (

    %p%\bin\CxImage.exe %%~fsi %COMPRESS_DIR%\%%~ni.gif 2 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.gif

)

(dir %1 /aa /b /s | findstr /e /c:"jpg") >tmp.txt

for /f "delims=" %%i in (tmp.txt) do (

    %p%\bin\CxImage.exe %%~fsi %COMPRESS_DIR%\%%~ni.jpg 3 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.jpg

)

(dir %1 /aa /b /s | findstr /e /c:"png") >tmp.txt

for /f "delims=" %%i in (tmp.txt) do (

    %p%\bin\CxImage.exe %%~fsi %COMPRESS_DIR%\%%~ni.png 4 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.png

)

echo.

echo.

del tmp.txt /q /f /s

echo 恭喜全部图片压缩完成啦, 立即查看:

pause

start "已压缩图片" %COMPRESS_DIR% & exit