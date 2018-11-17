@echo off
rem 这是一个图片压缩的批处理脚本，你只需要将图片所在的文件夹拖放使用本脚本打开，即可进行图片的批量压缩。
rem 图片压缩使用的是google开源工具guetzli,可配置参数只有一个“quality”（质量,本程序中可选值范围85~100）
rem 图片压缩质量
set QUALITY=85
setlocal enabledelayedexpansion
set p=%~dp0

for /f "delims=" %%i in ('dir /a-d /s /b') do (
     if "%%~xi" == ".JPG" ren "%%~fsi" "%%~ni.jpg"
     if "%%~xi" == ".jpeg" ren "%%~fsi" "%%~ni.jpg"
     if "%%~Xi" == ".JPEG" ren "%%~fsi" "%%~ni.jpg"
)
if "%PROCESSOR_ARCHITECTURE%%PROCESSOR_ARCHITEW6432%" == "x86" (
    set compressor=%p%x86\guetzli
) else (
    set compressor=%p%x86-64\guetzli
)
set parent_dir=%~dp1
for %%i in (dir %1) do set name=%%~nxi
set COMPRESS_DIR=%parent_dir%!name!-压缩副本
mkdir %COMPRESS_DIR%
echo 图片压缩后将被保存到"%COMPRESS_DIR%"

echo 开始批量压缩全部图片:
echo.
echo.
pause
echo.
echo.

(dir %1 /aa /b /s | findstr /e /c:"jpg") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi"正在压缩...
    %compressor% --quality %QUALITY% --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
    echo "%%~fsi"压缩完成
)
(dir %1 /aa /b /s | findstr /e /c:"png") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi"正在压缩...
    %compressor% --quality %QUALITY% --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
    echo "%%~fsi"压缩完成
)
echo.
echo.
del tmp.txt /q /f /s
echo 恭喜全部图片压缩完成啦, 立即查看:
pause
start "已压缩图片" %COMPRESS_DIR% & exit