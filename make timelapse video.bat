@echo off
REM ----------------------------------------------------------------------------
REM *                                                                          *
REM * This is a script meant to make a video out of the screenshots saved      *
REM *                     using the other script.                              *
REM *                                                                          *
REM * It will use ffmpeg, which must be installed on the system, and be in the *
REM *                 system path, or it will not work.                        *
REM *                                                                          *
REM *   The video will be saved in a folder called videos, in the same folder  *
REM *     as this script, and inside that folder several ones will be made,    *
REM *  storing each recording session (i.e. If the recording number is 1, the  *
REM *             video will be saved in .\videos\time-lapse.mp4               *
REM *                                                                          *
REM ----------------------------------------------------------------------------


REM Load video number from file (as text)
set /p num=< videoNum.txt
REM Convert video number to number (if not a number, will be converted to 0)
set /a videoNum=%num%
echo Creating video  #%videoNum%, press any key to continue...
pause>nul
IF NOT EXIST shots ( goto shotsFolderNotFound )
cd shots
REM Change to directory. If it doesn't exist, show an error
IF exist %videoNum% ( cd %videoNum% ) ELSE ( goto folderOfNumberNotFound )
REM If there is not first frame, skip rest, and echo reason
IF not exist shot000001.jpg ( goto framesNotFound )
REM Record a video from the frames (image2) with names from shot000000.jpg 
REM up until shot999999.jpg (shot%%06d.jpg), and save it as time-lapse.mp4
ffmpeg -f image2 -i shot%%06d.jpg time-lapse.mp4
echo.
echo.
echo Video created, moving it into \videos...
REM Making dir .\videos\%videoNum%
mkdir ..\..\videos\%videoNum%
REM Moving video from .\shots\%videoNum% to .\videos\%videoNum%
move time-lapse.mp4 ..\..\videos\%videoNum%
echo.
echo.
set /a nuevoNum=%num%+1
echo Updating video number from #%videoNum% to #%nuevoNum%
REM To ./shots
cd ..
REM To ./
cd ..
REM Remove previous video number
del videoNum.txt
REM Save video number to file
echo %nuevoNum% >videoNum.txt
echo Done! Press any key to continue...
pause>nul
exit

:shotsFolderNotFound
echo Shots folder could not be found, record the screenshots before making the video!
echo Press any key to exit...
pause>nul
exit

:folderOfNumberNotFound
echo Could not find folder for shots #%videoNum%, record the screenshots before making the video!
echo Press any key to exit...
pause>nul
exit

:framesNotFound
echo Frames not found, record the screenshots before making the video!
echo Press any key to exit... 
pause>nul 
exit