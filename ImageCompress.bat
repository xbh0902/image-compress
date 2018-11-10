@echo off
set ROOT=%TURBO_ROOT%
set CURRENT_DIR=%~dp0
set COMPRESS_DIR=%CURRENT_DIR%CompressedImage
echo ===============================================================================
echo.
echo 开始压缩当前目录下的图片，压缩后的图片将保存到:
echo "%COMPRESS_DIR%"目录
echo.
echo ===============================================================================
echo.
pause
if exist %COMPRESS_DIR% (
     @echo off
     echo 已存在该目录
) else (
      @echo off
      mkdir %COMPRESS_DIR%
      echo 已创建"%COMPRESS_DIR%"目录
)

if exist *.png (
    rem dir/b *.png
) else (
    @echo 当前目录下没有找到png格式图片
)

if exist *.jpg (
    rem dir/b *.jpeg
) else (
    @echo 当前目录下没有找到jpeg格式图片
)

for  %%x in (*.png) do (
    if not %%x=="ImageCompress.bat" (
        rem echo %%x
    )
)

for  %%x in (*.jpg) do (
       set input_file=%%x
       if not %input_file%=="ImageCompress.bat" (
           set temp_file=%COMPRESS_DIR%\%input_file%
           set out_file=%COMPRESS_DIR%\%input_file%
           rem echo %input_file%
           rem echo %temp_file%
           rem echo %out_file%
           if exist %temp_file% (
                del %temp_file%
                echo %temp_file% 已删除
           ) else (
                magick  "%input_file%"  "%temp_file%"
                echo %temp_file%
           )
       )
)


rem pause