@echo off
setlocal enabledelayedexpansion
set p=%~dp0
set COMPRESS_DIR=%p%CompressedImage
for /f "delims=" %%i in ('dir /a-d /s /b') do (
     if "%%~xi" == ".JPG" ren "%%~fsi" "%%~ni.jpg"
     if "%%~xi" == ".jpeg" ren "%%~fsi" "%%~ni.jpg"
     if "%%~Xi" == ".JPEG" ren "%%~fsi" "%%~ni.jpg"
)
mkdir %COMPRESS_DIR%
if "%PROCESSOR_ARCHITECTURE%%PROCESSOR_ARCHITEW6432%" == "x86" (
    set compressor=%p%\x86\guetzli
) else (
    set compressor=%p%\x86-64\guetzli
)

echo 开始批量压缩全部图片:
echo.
echo.
pause
echo.
echo.


(dir %1 /aa /b /s | findstr /e /c:"jpg") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi(正在压缩...)"
    %compressor% --quality 85 --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
)
(dir %1 /aa /b /s | findstr /e /c:"png") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi(正在压缩...)"
    %compressor% --quality 85 --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
    echo "%%~fsi(压缩完成)"
)
echo.
echo.
del tmp.txt /q /f /s
echo 恭喜全部图片压缩完成啦, 立即查看:
pause
start "已压缩图片" %COMPRESS_DIR% & exit