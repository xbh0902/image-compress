@echo off
set ROOT=%TURBO_ROOT%
set CURRENT_DIR=%~dp0
set COMPRESS_DIR=%CURRENT_DIR%CompressedImage
echo ===============================================================================
echo.
echo ��ʼѹ����ǰĿ¼�µ�ͼƬ��ѹ�����ͼƬ�����浽:
echo "%COMPRESS_DIR%"Ŀ¼
echo.
echo ===============================================================================
echo.
pause
if exist %COMPRESS_DIR% (
     @echo off
     echo �Ѵ��ڸ�Ŀ¼
) else (
      @echo off
      mkdir %COMPRESS_DIR%
      echo �Ѵ���"%COMPRESS_DIR%"Ŀ¼
)

if exist *.png (
    rem dir/b *.png
) else (
    @echo ��ǰĿ¼��û���ҵ�png��ʽͼƬ
)

if exist *.jpg (
    rem dir/b *.jpeg
) else (
    @echo ��ǰĿ¼��û���ҵ�jpeg��ʽͼƬ
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
                echo %temp_file% ��ɾ��
           ) else (
                magick  "%input_file%"  "%temp_file%"
                echo %temp_file%
           )
       )
)


rem pause