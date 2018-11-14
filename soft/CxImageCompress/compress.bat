@echo off
setlocal enabledelayedexpansion
set p=%~dp0
set COMPRESS_DIR=%p%CompressedImage
regsvr32.exe /s /i %p%\lib\CxImageATL.dll
for /f "delims=" %%i in ('dir /a-d /s /b') do (
     if "%%~xi" == ".JPG" ren "%%~fsi" "%%~ni.jpg"
     if "%%~xi" == ".jpeg" ren "%%~fsi" "%%~ni.jpg"
     if "%%~Xi" == ".JPEG" ren "%%~fsi" "%%~ni.jpg"
)
if exist tmp.txt (
    del tmp.txt /q /f /s
)
if exist %COMPRESS_DIR% (
     @echo off
     rem --> Clean dir
     del %COMPRESS_DIR%\* /q /f /s
) else (
      @echo off
      mkdir %COMPRESS_DIR%
      echo 已创建"%COMPRESS_DIR%"目录
      :: BatchGotAdmin
      :-------------------------------------
      rem --> Check for permissions
      >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

      rem --> If error flag set, we do not have admin.
      if '%errorlevel%' NEQ '0' (
      echo Requesting administrative privileges...
      goto UACPrompt
      ) else ( goto gotAdmin )

      :UACPrompt
      echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
      echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

      "%temp%\getadmin.vbs"
      exit /B

      :gotAdmin
      if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
      pushd "%CD%"
      CD /D "%~dp0"
      :--------------------------------------
      sc config winmgmt start= auto
)
echo 开始批量压缩全部图片:
echo.
echo.
pause
echo.
echo.

(dir %1 /aa /b /s | findstr /e /c:"bmp") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    %p%\bin\CxImage %%i %COMPRESS_DIR%\%%~ni.bmp 1 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.bmp
)
(dir %1 /aa /b /s | findstr /e /c:"gif") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    %p%\bin\CxImage %%i %COMPRESS_DIR%\%%~ni.gif 2 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.gif
)
(dir %1 /aa /b /s | findstr /e /c:"jpg") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    %p%\bin\CxImage %%i %COMPRESS_DIR%\%%~ni.jpg 3 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.jpg
)
(dir %1 /aa /b /s | findstr /e /c:"png") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    %p%\bin\CxImage %%i %COMPRESS_DIR%\%%~ni.png 4 60 > nul & echo %%i----%COMPRESS_DIR%\%%~ni.png
)
echo.
echo.
del tmp.txt /q /f /s
echo 恭喜全部图片压缩完成啦, 立即查看:
pause
start "已压缩图片" %COMPRESS_DIR% & exit