@echo off
REM ----------------------------------------------------------------------------
REM *                                                                          *
REM * This script is meant to save a screenshot of the screen once every 10    *
REM *                                 seconds.                                 *
REM *                                                                          *
REM * It will use ffmpeg, which must be installed on the system, and be in the *
REM *                     system path, or it will not work.                    *
REM *                                                                          *
REM *   Also note thatm in order to save a snapshot of the screen, the video   *
REM *   input "UScreenCapture" is used, so you must make sure your system has  *
REM *                                   it.                                    *
REM *                                                                          *
REM *    The screenshots will be saved in a folder called shots in the same    *
REM * folder as this script, and inside that folder several ones will be made, *
REM *  storing each recording session (i.e. If the recording number is 1, the  *
REM *   shots will be saved in .\shots\shotXXXXXX.jpg, where the X's are the   *
REM *           shot's number, padded with 0's up to the 6th digit)            *
REM *                                                                          *
REM ----------------------------------------------------------------------------

REM Load video number from file (as text)
set /p num=< videoNum.txt
REM Convert video number from file (which is loaded as text) to a
REM number (if could not be parsed as a number, it will be converted to 0)
set /a videoNum=%num%
echo Recording video number %videoNum%, press any key to continue
pause>nul
IF NOT exist shots mkdir shots
cd shots
REM If the folder exists ask the user what to do. If it does not exits, make it
IF exist %num% ( call :alreadyExists ) ELSE ( mkdir %videoNum% && cd %videoNum% )
:continue1
echo.
echo.
echo.
REM Record screen (dshow & UScreenCapture) to a set of images (image2) at 1 frame each 10 seconds (1/10) and save them from shot000000.jpg to shot999999.jpg (shot%%06d.jpg)
ffmpeg -y -f dshow -r 1 -i video="UScreenCapture" -f image2 -vf fps=fps=1/10 shot%%06d.jpg
echo.
echo.
echo.
echo Done! Press any key to continue...
pause>nul
exit

:alreadyExists

REM If the folder already exists, ask the user whether they want to continue or exit.
echo The folder with the number %videoNum% already exists
CHOICE /C:CX /M "Pulsa C para continuar and delete the contents, or X to exit"
IF ERRORLEVEL 2 ( exit )
cd %videoNum%
del *.* /f /q
goto:EOF
