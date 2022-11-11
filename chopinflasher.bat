@echo off
set ver=1.31
color 0a
title Chopin MIUI 12 Flasher Script v%ver% by Ali BEYAZ
echo.
echo Welcome to Chopin Flasher Script. Do it at your own risk.
echo Go fastboot mode on your phone to begin.
echo.
goto checksdkfiles

:checksdkfiles
if not exist sdk\adb.exe goto notsdkfound
if not exist sdk\fastboot.exe goto notsdkfound
if not exist sdk\AdbWinApi.dll goto notsdkfound
if not exist sdk\AdbWinUsbApi.dll goto notsdkfound
goto romconfirm

:romconfirm
set /P c=Do you want to check ROM files [Y/N]?
if /I "%c%" EQU "Y" goto checkromfiles
if /I "%c%" EQU "N" goto userdata
goto romconfirm

:checkromfiles
if not exist images\lk.img goto notfound
if not exist images\dpm.img goto notfound
if not exist images\preloader_chopin.bin goto notfound
if not exist images\tee.img goto notfound
if not exist images\mitee.img goto notfound
if not exist images\sspm.img goto notfound
if not exist images\gz.img goto notfound
if not exist images\scp.img goto notfound
if not exist images\logo.bin goto notfound
if not exist images\dtbo.img goto notfound
if not exist images\spmfw.img goto notfound
if not exist images\mcupm.img goto notfound
if not exist images\pi_img.img goto notfound
if not exist images\md1img.img goto notfound
if not exist images\cam_vpu1.img goto notfound
if not exist images\cam_vpu2.img goto notfound
if not exist images\cam_vpu3.img goto notfound
if not exist images\audio_dsp.img goto notfound
if not exist images\super.img goto notfound
if not exist images\rescue.img goto notfound
if not exist images\cust.img goto notfound
if not exist images\vbmeta.img goto notfound
if not exist images\vbmeta_system.img goto notfound
if not exist images\vbmeta_vendor.img goto notfound
if not exist images\userdata.img goto notfound
if not exist images\boot.img goto notfound
echo ROM files are OK
echo.
goto userdata

:userdata
echo If you want to do flash a different region ROM, you should erase USERDATA.
set /P c=Do you want to ERASE USERDATA [Y/N]?
if /I "%c%" EQU "Y" goto erase
if /I "%c%" EQU "N" goto noterase
goto userdata


:erase
echo Erasing USERDATA
sdk\fastboot erase metadata || @echo "Erase metadata error"
sdk\fastboot flash userdata         images\userdata.img          || @echo "Flash userdata error"
goto startflashing

:noterase
echo Saving USERDATA
goto startflashing

:startflashing
echo.
echo Flashing...
if exist images\boot.img sdk\fastboot erase boot_ab || @echo "Erase boot error"
sdk\fastboot erase expdb || @echo "Erase expdb error"
sdk\fastboot flash preloader_ab images\preloader_chopin.bin  || @echo "Flash preloader error"
sdk\fastboot flash lk_ab       images\lk.img         || @echo "Flash lk_b       error"
sdk\fastboot flash dpm_ab     images\dpm.img        || @echo "Flash dpm       error"
sdk\fastboot flash tee_ab      images\tee.img        || @echo "Flash tee_a      error"
sdk\fastboot flash mitee_ab    images\mitee.img      || @echo "Flash mitee error"
sdk\fastboot flash sspm_ab    images\sspm.img       || @echo "Flash sspm_b    error"
sdk\fastboot flash gz_ab       images\gz.img         || @echo "Flash gz_a       error"
sdk\fastboot flash scp_ab      images\scp.img        || @echo "Flash scp_a      error"
sdk\fastboot flash logo      images\logo.bin       || @echo "Flash logo      error"
sdk\fastboot flash dtbo_ab      images\dtbo.img       || @echo "Flash dtbo      error"
sdk\fastboot flash spmfw_ab     images\spmfw.img      || @echo "Flash spmfw     error"
sdk\fastboot flash mcupm_ab   images\mcupm.img      || @echo "Flash mcupm     error"
sdk\fastboot flash pi_img_ab    images\pi_img.img     || @echo "Flash pi_img    error"
sdk\fastboot flash md1img_ab    images\md1img.img     || @echo "Flash md1img    error"
sdk\fastboot flash cam_vpu1_ab  images\cam_vpu1.img   || @echo "Flash cam_vpu1  error"
sdk\fastboot flash cam_vpu2_ab  images\cam_vpu2.img   || @echo "Flash cam_vpu2  error"
sdk\fastboot flash cam_vpu3_ab  images\cam_vpu3.img   || @echo "Flash cam_vpu3  error"
sdk\fastboot flash audio_dsp_ab images\audio_dsp.img  || @echo "Flash audio_dsp error"
sdk\fastboot flash super            images\super.img             || @echo "Flash super    error"
sdk\fastboot flash rescue            images\rescue.img           || @echo "Flash rescue   error"
sdk\fastboot flash vbmeta_ab           images\vbmeta.img            || @echo "Flash vbmeta   error"
sdk\fastboot flash vbmeta_system_ab    images\vbmeta_system.img     || @echo "Flash vbmeta_system   error"
sdk\fastboot flash vbmeta_vendor_ab    images\vbmeta_vendor.img     || @echo "Flash vbmeta_vendor   error"
sdk\fastboot flash cust         		images\cust.img        		|| @echo "Flash cust 			error"
sdk\fastboot flash boot_ab             images\boot.img              || @echo "Flash boot     error"
sdk\fastboot oem cdms
sdk\fastboot set_active a  || @echo "set_active a error"
echo.
echo Success!
echo.
goto verityconfirm

:verityconfirm
set /P c=Do you want to DISABLE VERITY [Y/N]?
if /I "%c%" EQU "Y" goto verity
if /I "%c%" EQU "N" goto exit
goto verityconfirm

:verity
sdk\fastboot flash vbmeta --disable-verity --disable-verification vbmeta.img|| @echo "Disable verity is not success. Check vbmeta.img"
goto exit

:notsdkfound
echo Make sure extract minimal ADB and fastboot files on "SDK" folder and rerun script again.
echo.
goto exit

:notfound
echo Make sure extract "images" folder of fastboot ROM's tgz file and rerun script again.
echo You can open fastboot ROM's tgz file via Winrar.
echo.
goto exit

:exit
sdk\fastboot reboot
pause
exit

