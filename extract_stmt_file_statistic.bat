SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS
@echo off
REM This script is meant for e-statement FTP uploading statistic report, which is triggered during next morning's health monitoring
REM job schedule - 6am in the morning, every Tuesday to Saturday  
REM date format - "www mm/dd/yyyy"
REM <how to debug>
REM login to ftp server thru remote desktop client
REM launch windows command line
REM run C:\Scripts>extract_stmt_file_statistic.bat > 1.log 2>1&

REM modified by jc 30/09/2016
REM 	added contract stmt and contract amendment
REM modified by jc 25/11/2016
REM	changed cfd daily/monthly statement name

IF ERRORLEVEL 1 echo Unable to enable extensions

if "%1"=="UAT" (
	set FTP_FOLDER=c:\SGXSSH\eStatementUAT
) else (
	if "%1"=="PROD" (
		set FTP_FOLDER=c:\eStatementProd
	) else (
		set FTP_FOLDER=d:\eStatementSIT
	)
)

set LOG_PATH=%FTP_FOLDER%\Logs
if not exist %LOG_PATH% mkdir %LOG_PATH%

set MYLOG=%LOG_PATH%\statement_upload.rpt
set YYYY=%date:~10,4%
set DD=%date:~7,2%
set MM=%date:~4,2%
set WKDAY=%date:~0,3%

set PREV_DD=
set PREV_MM=
set PREV_YYYY=

set NEXT_DD=
set NEXT_MM=
set NEXT_YYYY=

REM calculate previous day - no leap year handling!

REM default prev day = current day - 1
set /a PREV_DD=%DD%
REM set /a PREV_MM=%MM%
set PREV_MM=%MM%
set /a PREV_YYYY=%YYYY%

set Digit1=%DD:~0,1%
set Digit2=%DD:~1,1%

REM echo 1st digit of DD %Digit1%
REM echo 2nd digit of DD %Digit2%

REM date = 01 - 09, 10 - 31
if "%DD%" LSS "10" (
	set /a MYTMP=%Digit2%-1
) else (
	set /a MYTMP=%DD%-1
)
	
if %MYTMP% LSS 10 (
	set PREV_DD=0%MYTMP%
) else (
	set PREV_DD=%MYTMP%
)


REM 1st day of month hanlding
if "%DD%"=="01" (
	if "%MM%"=="01" (
		set PREV_DD=31
		set PREV_MM=12
		set /a PREV_YYYY=%YYYY%-1
	) else (
		if "%MM%"=="02" (
			set PREV_DD=31
			set PREV_MM=01
			set PREV_YYYY=%YYYY%
		) else (
			if "%MM%"=="03" (
				set PREV_DD=28
				set PREV_MM=02
				set PREV_YYYY=%YYYY%
			) else (
				if "%MM%"=="04" (
					set PREV_DD=31
					set PREV_MM=03
					set PREV_YYYY=%YYYY%
				) else (
					if "%MM%"=="05" (
						set PREV_DD=30
						set PREV_MM=04
						set PREV_YYYY=%YYYY%
					) else (
						if "%MM%"=="06" (
							set PREV_DD=31
							set PREV_MM=05
							set PREV_YYYY=%YYYY%
						) else (
							if "%MM%"=="07" (
								set PREV_DD=30
								set PREV_MM=06
								set PREV_YYYY=%YYYY%
							) else (
								if "%MM%"=="08" (
									set PREV_DD=31
									set PREV_MM=07
									set PREV_YYYY=%YYYY%
								) else (
									if "%MM%"=="09" (
										set PREV_DD=31
										set PREV_MM=08
										set PREV_YYYY=%YYYY%
									) else (
										if "%MM%"=="10" (
											set PREV_DD=30
											set PREV_MM=09
											set PREV_YYYY=%YYYY%
										) else (
											if "%MM%"=="11" (
												set PREV_DD=31
												set PREV_MM=10
												set PREV_YYYY=%YYYY%
											) else (
												if "%MM%"=="12" (
													set PREV_DD=30
													set PREV_MM=11
													set PREV_YYYY=%YYYY%
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
) 


REM -------------------------------------------------------------------------------
REM calculate next day - no leap year handling!

set /a NEXT_DD=%DD%
REM set /a NEXT_MM=%MM%
set NEXT_MM=%MM%
set /a NEXT_YYYY=%YYYY%

REM check if date = 01 to 09, or 10 - 31
if "%DD%" LSS "10" (
	set /a MYTMP=%Digit2%+1
) else (
	set /a MYTMP=%DD%+1
)

if %MYTMP% LSS 10 (
	set NEXT_DD=0%MYTMP%
) else (
	set NEXT_DD=%MYTMP%
)

REM last day of month handling
if "%MM%"=="12" (
	if "%DD%"=="31" (
		set NEXT_DD=01
		set NEXT_MM=01
		set /a NEXT_YYYY=%YYYY%+1
	) 
) else (
	if "%MM%"=="01" (
		if "%DD%"=="31" (
			set NEXT_DD=01
			set NEXT_MM=02
		)
	) else (
		if "%MM%"=="02" (
			if "%DD%"=="28" (
				set NEXT_DD=01
				set NEXT_MM=03
			)
		) else (
			if "%MM%"=="03" (
				if "%DD%"=="31" (
					set NEXT_DD=01
					set NEXT_MM=04
				)
			) else (
				if "%MM%"=="04" (
					if "%DD%"=="30" (
						set NEXT_DD=01
						set NEXT_MM=05
					)
				) else (
					if "%MM%"=="05" (
						if "%DD%"=="31" (
							set NEXT_DD=01
							set NEXT_MM=06
						)
					) else (
						if "%MM%"=="06" (
							if "%DD%"=="30" (
								set NEXT_DD=01
								set NEXT_MM=07
							)
						) else (
							if "%MM%"=="07" (
								if "%DD%"=="31" (
									set NEXT_DD=01
									set NEXT_MM=08
								)
							) else (
								if "%MM%"=="08" (
									if "%DD%"=="31" (
										set NEXT_DD=01
										set NEXT_MM=09
									)
								) else (
									if "%MM%"=="09" (
										if "%DD%"=="30" (
											set NEXT_DD=01
											set NEXT_MM=10
										)
									) else (
										if "%MM%"=="10" (
											if "%DD%"=="31" (
												set NEXT_DD=01
												set NEXT_MM=11
											)
										) else (
											if "%MM%"=="11" (
												if "%DD%"=="30" (
													set NEXT_DD=01
													set NEXT_MM=12
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)
)


echo prev day is [%PREV_YYYY% %PREV_MM% %PREV_DD%]
echo current day is [%YYYY% %MM% %DD%]
echo next day is [%NEXT_YYYY% %NEXT_MM% %NEXT_DD%]

REM For monthly statement posting - get last month value [0-9][0-9]
REM usually monthly stmt file name will be *.yyyymm.*.txt and mm = last month

set Digit1=%MM:~0,1%
set Digit2=%MM:~1,1%

REM check if month = 01 to 09, or 10 - 12
if "%MM%" LSS "10" (
	set /a MYTMP=%Digit2%-1
) else (
	set /a MYTMP=%MM%-1
)

if %MYTMP% LSS 10 (
	set PREV_MM2=0%MYTMP%
) else (
	set PREV_MM2=%MYTMP%
)

set PREV_YYYY2=%YYYY%

if "%MM%"=="01" (
	set PREV_MM2=12
	set /a PREV_YYYY2=%YYYY%-1
) 

echo prev month (for monthly stmt) is [%PREV_YYYY2% %PREV_MM2%]

REM print report header with date/time stamp
echo.>> %MYLOG%
echo ================================================================================ >> %MYLOG%
echo.>> %MYLOG%
echo Lim and Tan Statement Uploading Statistic Report - [%date%] [%time%] >> %MYLOG%
echo.>> %MYLOG%
REM echo "Date/Time:" >> %MYLOG%
REM date /t >> %MYLOG%
REM time /t >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 13. SGX contract statement (daily)
set STMT_DESC=Contract Statement Daily
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\Contract\ContStmt\DR\CONTSTMT_%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\Contract\ContStmt\backup\CONTSTMT_%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt

set ERR_MSG="<WARN> Contract statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		goto NEXT5
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)


REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

REM STP only make use of no of lines for e-contract proj
set RECORD_CNT=%NumOfLines%

echo [13] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%

:NEXT5

REM -------------------------------------------------------------------------------
REM 14. SGX contract amendment (daily)
set STMT_DESC=Contract Amendment Daily
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\Contract\ContAmend\DR\CONTAMEND_%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\Contract\ContAmend\backup\CONTAMEND_%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt

set ERR_MSG="<WARN> Contract amendment control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		goto NEXT6
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)


REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

REM STP only make use of no of lines for e-contract proj
set RECORD_CNT=%NumOfLines%

echo [14] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%

:NEXT6


REM -------------------------------------------------------------------------------
REM 1. cfd daily statement
set STMT_DESC=CFD Daily Statement
set RECORD_CNT=

REM set STMT_CTR_FILE1=%FTP_FOLDER%\CFD\Daily\DR\CFD_DAILY_APPGRP.CFD_DAILY_APP.CFD_DAILY.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
REM set STMT_CTR_FILE2=%FTP_FOLDER%\CFD\Daily\backup\CFD_DAILY_APPGRP.CFD_DAILY_APP.CFD_DAILY.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE1=%FTP_FOLDER%\CFD\Daily\DR\LTS.CFD_DAILY_APPGRP.CFD_DAILY_APP.CFD_DAILY.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\CFD\Daily\backup\LTS.CFD_DAILY_APPGRP.CFD_DAILY_APP.CFD_DAILY.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt


set ERR_MSG="<WARN> CFD daily statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		goto NEXT2
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)


REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [1] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%

:NEXT2

REM -------------------------------------------------------------------------------
REM 2. cfd monthly statement - *yyyymmdd_done.txt
REM    cfd monthly statement - control file name contains current system date yyyymmdd
set STMT_DESC=CFD Monthly Statement
set RECORD_CNT=

REM set STMT_CTR_FILE1=%FTP_FOLDER%\CFD\Monthly\DR\CFD_MONTHLY_APPGRP.CFD_MONTHLY_APP.CFD_MONTHLY.%PREV_YYYY2%%PREV_MM2%??_done.txt
REM set STMT_CTR_FILE2=%FTP_FOLDER%\CFD\Monthly\backup\CFD_MONTHLY_APPGRP.CFD_MONTHLY_APP.CFD_MONTHLY.%PREV_YYYY2%%PREV_MM2%??_done.txt

set STMT_CTR_FILE1=%FTP_FOLDER%\CFD\Monthly\DR\LTS.CFD_MONTHLY_APPGRP.CFD_MONTHLY_APP.CFD_MONTHLY.%YYYY%%MM%??_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\CFD\Monthly\backup\LTS.CFD_MONTHLY_APPGRP.CFD_MONTHLY_APP.CFD_MONTHLY.%YYYY%%MM%??_done.txt

set ERR_MSG="<WARN> CFD monthly statement control file not available, please check FTP serevr"

REM echo %STMT_CTR_FILE1% >> %MYLOG%
REM echo %STMT_CTR_FILE2% >> %MYLOG%

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		goto NEXT3
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)


if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	goto NEXT3
)


REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%


REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [2] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%

:NEXT3

REM -------------------------------------------------------------------------------
REM 3.1 Contra daily statement - fish out
set STMT_DESC=Contra Daily Statement - fishout
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\Contra\DR\LTS.CONTRA.FishOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\Contra\Backup\LTS.CONTRA.FishOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt

set ERR_MSG="<WARN> Contra daily statement control file - fishout not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		goto NEXT4
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	goto NEXT4
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [3.1] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


:NEXT4

REM -------------------------------------------------------------------------------
REM 3.2 Contra daily statement - mail out
set STMT_DESC=Contra Daily Statement - mailout
set RECORD_CNT=

REM set STMT_CTR_FILE1=%FTP_FOLDER%\Contra\LTS.CONTRA.MailOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
REM set STMT_CTR_FILE2=%FTP_FOLDER%\Contra\Backup\LTS.CONTRA.MailOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE1=%FTP_FOLDER%\Contra\DR\LIMTAN.CONTRA.MailOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\Contra\Backup\LIMTAN.CONTRA.MailOut.%PREV_YYYY%%PREV_MM%%PREV_DD%_done.txt

set ERR_MSG="<WARN> Contra daily statement control file - mailout not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 3
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 3
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [3.2] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 4 CBS monthly statement
set STMT_DESC=CBS Monthly Statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\CBSMthlyStmt_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\CBSMthlyStmt_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> CBS monthly statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 4
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 4
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [4] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 5 CBS Tax Invoice statement - quarterly stmt, only avail on march, june, sept, dec month end
set STMT_DESC=CBS Tax Invoice
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\CBSTaxInv_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\CBSTaxInv_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> CBS Tax invoice control file not available, please check FTP serevr"
set ERR_MSG2="+ Be noted, tax invoice stmt only avail on Mar/Jun/Sept/Dec month end    +"

REM remove all quotes from variable
set ERR_MSG2=%ERR_MSG2:"=%

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %MYLOG%
		echo %ERR_MSG2% >> %MYLOG%
		echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %MYLOG%
		
		goto NEXT1
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %MYLOG%	
	echo %ERR_MSG2% >> %MYLOG%	
	echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ >> %MYLOG%	
	goto NEXT1
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [5] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


:NEXT1

REM -------------------------------------------------------------------------------
REM 6 CCT monthly statement - security holding
set STMT_DESC=CCT Monthly Statement - security holding
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\CCTSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\CCTSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> CCT monthly statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 6
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 6
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [6] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 7 Dividend monthly statement
set STMT_DESC=Dividend monthly statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\DIVSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\DIVSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Dividend monthly statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 7
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 7
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [7] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 8 Monthly Trust statement
set STMT_DESC=Monthly Trust statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\MonthlyTrustStatement_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\MonthlyTrustStatement_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Monthly Trust statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 8
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 8
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [8] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 9 Ledger monthly statement
set STMT_DESC=Ledger Monthly Statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\LedgerStmt_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\LedgerStmt_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Ledger monthly statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 9
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 9
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [9] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 10 Margin monthly statement
set STMT_DESC=Margin Monthly Statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\MarginStmt_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\MarginStmt_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Margin Monthly Statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 10
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 10
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [10] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 11 Margin Stock Position statement
set STMT_DESC=Margin Stock Position Statement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\MARGINSTKPOS_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\MARGINSTKPOS_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Margin Stock Position Statement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 11
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 11
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [11] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM -------------------------------------------------------------------------------
REM 12 Monthly Trust Acct Movement
set STMT_DESC=Monthly Trust Acct Movement
set RECORD_CNT=

set STMT_CTR_FILE1=%FTP_FOLDER%\MonthlyStatement\DR\TRUSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt
set STMT_CTR_FILE2=%FTP_FOLDER%\MonthlyStatement\Backup\TRUSTMT_%PREV_YYYY2%%PREV_MM2%_done.txt

set ERR_MSG="<WARN> Monthly Trust Acct Movement control file not available, please check FTP serevr"

if not exist %STMT_CTR_FILE1% (
	if not exist %STMT_CTR_FILE2% (
		echo.>> %MYLOG%
		echo %ERR_MSG% >> %MYLOG%
		echo.>> %MYLOG%
		exit 12
	) else (
		for %%f in (%STMT_CTR_FILE2%) do set STMT_CTR_FILE=%%f
	)
) else (
	for %%f in (%STMT_CTR_FILE1%) do set STMT_CTR_FILE=%%f
)

if not exist %STMT_CTR_FILE% (
	echo.>> %MYLOG%
	echo %ERR_MSG% >> %MYLOG% 
	echo.>> %MYLOG%
	exit 12
)

REM retrieve first line
for /f "tokens=* delims= " %%i in (%STMT_CTR_FILE%) do set ALine=%%i
set NumOfLines=%ALine:~0,10%
set NumOfClients=%ALine:~10,10%

REM trim leading zeros
for /f "tokens=* delims=0" %%i in ("%NumOfLines%") do set NumOfLines=%%i
for /f "tokens=* delims=0" %%i in ("%NumOfClients%") do set NumOfClients=%%i

set RECORD_CNT=%NumOfClients%

echo [12] %STMT_DESC% - %RECORD_CNT% >> %MYLOG%


REM end of report
echo.>> %MYLOG%
echo ====EOF==== >> %MYLOG%
echo.>> %MYLOG%

