:: ����һ��ͼƬѹ����������ű�����ֻ��Ҫ��ͼƬ���ڵ��ļ����Ϸ�ʹ�ñ��ű��򿪣����ɽ���ͼƬ������ѹ����
:: ͼƬѹ��ʹ�õ���google��Դ����guetzli,�����ò���ֻ��һ����quality��������,�������п�ѡֵ��Χ85~100��
@echo off
:: ͼƬѹ������
set QUALITY=90
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

echo ��ʼ����ѹ��ȫ��ͼƬ:
echo.
echo.
pause
echo.
echo.

(dir %1 /aa /b /s | findstr /e /c:"jpg") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi(����ѹ��...)"
    %compressor% --quality %QUALITY% --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
    echo "%%~fsi(ѹ�����)"
)
(dir %1 /aa /b /s | findstr /e /c:"png") >tmp.txt
for /f "delims=" %%i in (tmp.txt) do (
    echo "%%~fsi(����ѹ��...)"
    %compressor% --quality %QUALITY% --verbose %%~fsi %COMPRESS_DIR%\%%~ni.jpg
    echo "%%~fsi(ѹ�����)"
)
echo.
echo.
del tmp.txt /q /f /s
echo ��ϲȫ��ͼƬѹ�������, �����鿴:
pause
start "��ѹ��ͼƬ" %COMPRESS_DIR% & exit