@ECHO OFF
@TITLE Wifi热点编辑工具 v2.0

set help=0
if "%1" == "/?" ( set help=1 )
if "%1" == "help" ( set help=1 )
if "%1" == "-help" ( set help=1 )

if %help% == 1 (
	echo Wifi热点编辑工具
	echo 用法:
		echo 	%0 [ create ^| start ^| stop ^| view ^| help ]
	echo 用法解释：
	echo 	create：用于创建一个热点，配置并启动
	echo 	start：启动热点 （无法在热点未创建时使用）
	echo 	stop：停止热点
	echo 	view：查看热点状态
	echo 	help：显示帮助
	exit /b 0
)

net session >nul 2>&1
if not "%errorLevel%" == "0" (
	echo 此程序需要提供管理员权限，诺UAC弹窗弹出请点 【是】
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin.vbs"
	
	"%temp%\getadmin.vbs"
	exit /b 2
)

if "%1"=="create" goto createMINI
if "%1"=="start" goto startMINI
if "%1"=="stop" goto stopMINI
if "%1"=="view" goto viewConnectMINI

:pre-roll-1
mode con: cols=44 lines=25
cls
color 6E
echo 程序开始检查系统是否支持承载网络模式
set SupportAD-Hoc=0
netsh wlan show drive | find "支持的承载网络" | find "是"
if %errorlevel%==0 set SupportAD-Hoc=1

if %SupportAD-Hoc%==1 (
	set ad-hoc=是
) else (
	set ad-hoc=否
)

goto pre-roll-2

:pre-roll-2
if %ad-hoc%==否 goto NetCardNotSupported
goto pre-roll-3

:NetCardNotSupported
cls
color CF
echo 程序发现您的网卡不支持承载网络
set /p continue=继续吗？ [Y/n]: 
if %continue%=y goto pre-roll-3
if %continue%=Y goto pre-roll-3
if %continue%=n goto goto end
if %continue%=N goto goto end

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto netCardNotSupported

:pre-roll-3
color 6E
set stateOnOff=0
netsh wlan show hostednetwork | find "状态" | find "已启动"
if %errorlevel%==0 set stateOnOff=1
if %stateOnOff%==1 (
	set S=启动
) else (
	set S=关闭
)

set hostednetworkMode=0
netsh wlan show hostednetwork | find "模式" | find "已启用"
if %errorlevel%==0 (
	set s2=启用
) else (
	set s2=禁用
)
cls
goto MainMenu

:MainMenu
color 3F
cls

echo.
echo.
echo        ┌—————————————┐
echo        │  Wifi热点编辑工具 v2.0   │
echo        │			   │
echo        │ 1 创建Wifi热点           │
echo        │ 2 启动Wifi热点           │
echo        │ 3 停止Wifi热点           │
echo        │ 4 查看Wifi热点状态	   │
echo        │ 5 查看Wifi热点密码	   │
echo        │ 6 更改Wifi热点设置       │
echo        │ 7 退出                   │
echo        └—————————————┘
echo           ┌——————————┐
echo           │        状态：      │
echo           │ 支持承载网络：%ad-hoc%   │  
echo           │ 承载网络模式：%s2% │
echo           │ 承载网络状态：%S% │
echo           └——————————┘

set /p sel1=请选择 1-7 的命令，按Enter继续：
if "%sel1%"=="1" goto create
if "%sel1%"=="2" goto start
if "%sel1%"=="3" goto stop
if "%sel1%"=="4" goto viewConnect
if "%sel1%"=="5" goto viewPWD
if "%sel1%"=="6" goto changeSettings
if "%sel1%"=="7" goto end

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto MainMenu

:create
mode con: cols=44 lines=25
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        输入Wifi名称      │
echo        │                          │
echo        └—————————————┘

if "%WifiName%"=="" set WifiName=WLAN_Hotspot
set /p WifiName=请输入WIFI热点SSID/名字（默认: %WifiName%）：
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        输入Wifi密码      │
echo        │                          │
echo        └—————————————┘

set /p WifiKey=请输入WIFI热点的密码（必需，密码长度为 8~63 字符）：

netsh wlan set hostednetwork mode=allow ssid=%WifiName% key=%WifiKey% > nul
netsh wlan start hostednetwork > nul
if %errorlevel%==0 (
	cls
	color 2F
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点创建成功    │
	echo        │                          │
	echo        └—————————————┘
	echo 记得在控制面板 --^> 查看网络状态和任务 --^> 更改适配器设置 --^> 右键 “无线网络连接” --^> 属性 --^> 共享 --^> 勾选 “允许其他网络用户通过此计算机的 Internet 连接来连接” 然后选择 “无线网络连接 2” --^> 确定
	echo.
	echo 按下任意键来返回菜单...
	pause > nul
	cls
	goto pre-roll-3
) else (
	cls
	color CF
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点创建失败    │
	echo        │                          │
	echo        └—————————————┘
	echo 按下任意键来返回菜单...
	pause > nul
	cls
	goto pre-roll-3
)

:start
netsh wlan start hostednetwork
if %errorlevel%==0 (
	cls
	color 2F
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点启动成功    │
	echo        │                          │
	echo        └—————————————┘
	echo 按下任意键来返回菜单...
	pause > nul
	cls
	goto pre-roll-3
) else (
	cls
	color CF
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点启动失败    │
	echo        │                          │
	echo        └—————————————┘
	echo 按下任意键来返回菜单...
	pause > nul
	cls
	goto pre-roll-3
)

:stop
netsh wlan stop hostednetwork
cls
color 2F
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      Wifi热点停止成功    │
echo        │                          │
echo        └—————————————┘
echo 按下任意键来返回菜单...
pause > nul
cls
goto pre-roll-3

:viewConnect
cls
mode con: cols=82 lines=25
netsh wlan show hostednetwork
echo 按下任意键来返回菜单
pause > nul
mode con: cols=44 lines=25
goto MainMenu

:viewPWD
cls
mode con: cols=82 lines=25
netsh wlan show hostednetwork setting=security
echo 按下任意键来返回菜单
pause > nul
mode con: cols=44 lines=25
goto MainMenu

:changeSettings
cls
echo.
echo.
echo        ┌—————————————┐
echo        │       Wifi热点设置       │
echo        │			   │
echo        │ 1 更改WIFI密码           │
echo        │ 2 更改WIFI名称           │
echo        │ 3 删除/禁用热点          │
echo        │ 4 启动Wifi热点    	   │
echo        │ 5 返回	           │
echo        └—————————————┘

set /p sel2=请选择 1-5 的命令，按Enter继续：
if "%sel2%"=="1" goto ChangePWD
if "%sel2%"=="2" goto ChangeSSID
if "%sel2%"=="3" goto DeleteHotspot
if "%sel2%"=="4" goto EnableHotspot
if "%sel2%"=="5" goto MainMenu

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto changeSettings

:ChangePWD
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        新密码向导	   │
echo        │                          │
echo        └—————————————┘

set /p NewKEY=请输入新的密码：
echo.
echo 密码为：%NewKEY%
set /p sel3=确认使用新密码？[Y/n]:
if "%sel3%"=="Y" goto ChangePWD-Afirmative
if "%sel3%"=="y" goto ChangePWD-Afirmative
if "%sel3%"=="N" goto MainMenu
if "%sel3%"=="n" goto MainMenu

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto ChangePWD

:ChangePWD-Afirmative
netsh wlan set hostednetwork key=%NewKEY%
cls
color 2F
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      新密码创建完成	   │
echo        │                          │
echo        └—————————————┘
echo 新密码为：%NewKEY%
echo 按下任意键来返回菜单
pause > nul
goto MainMenu

:ChangeSSID
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        新SSID向导	   │
echo        │                          │
echo        └—————————————┘

set /p NewSSID=请输入新的SSID/名字：
echo.
echo 新的SSID/名字为：%NewSSID%
set /p sel4=确认使用新SSID/名字？[Y/n]:
if "%sel4%"=="Y" goto ChangeSSID-Afirmative
if "%sel4%"=="y" goto ChangeSSID-Afirmative
if "%sel4%"=="N" goto MainMenu
if "%sel4%"=="n" goto MainMenu

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto ChangeSSID


:ChangeSSID-Afirmative
netsh wlan set hostednetwork key=%NewKEY%
cls
color 2F
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      新SSID创建完成	   │
echo        │                          │
echo        └—————————————┘
echo 新的SSID/名字为：%NewSSID%
echo 按下任意键来返回菜单
pause > nul
goto MainMenu

:DeleteHotspot
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      删除Wifi热点向导	   │
echo        │                          │
echo        └—————————————┘

set /p sel5=您确定要删除/禁用Wifi热点吗？[Y/n]:
if "%sel5%"=="Y" goto DeleteHotspot-Afirmative
if "%sel5%"=="y" goto DeleteHotspot-Afirmative
if "%sel5%"=="N" goto MainMenu
if "%sel5%"=="n" goto MainMenu

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto DeleteHotspot

:DeleteHotspot-Afirmative
cls
netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
color 2F
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      删除Wifi热点成功	   │
echo        │                          │
echo        └—————————————┘
echo 按下任意键来返回菜单
pause > nul
goto pre-roll-3

:EnableHotspot
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      启用Wifi热点向导	   │
echo        │                          │
echo        └—————————————┘

set /p sel6=您确定要启用Wifi热点吗？[Y/n]:
if "%sel6%"=="Y" goto EnableHotspot-Afirmative
if "%sel6%"=="y" goto EnableHotspot-Afirmative
if "%sel6%"=="N" goto MainMenu
if "%sel6%"=="n" goto MainMenu
echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto EnableHotspot


:EnableHotspot-Afirmative
netsh wlan set hostednetwork mode=allow
color 2F
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │      启用Wifi热点成功	   │
echo        │                          │
echo        └—————————————┘
echo 按下任意键来返回菜单
pause > nul
goto pre-roll-3

:end
pause
set help=
set SupportAD-Hoc=
set ad-hoc=
set continue=
set stateOnOff=
set S=
set s2=
set sel1=
set WifiName=
set sel2=
set NewKEY=
set sel3=
set NewSSID=
set sel4=
set sel5=
set sel6=
color
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
exit

:startMINI
netsh wlan start hostednetwork > nul
echo Wifi热点已启动
goto end

:stopMINI
netsh wlan stop hostednetwork > nul
echo Wifi热点已关闭
goto end

:viewConnectMINI
netsh wlan show hostednetwork
pause
exit

:createMINI
mode con: cols=44 lines=25
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        输入Wifi名称      │
echo        │                          │
echo        └—————————————┘

if "%WifiName%"=="" set WifiName=WLAN_Hotspot
set /p WifiName=请输入WIFI热点SSID/名字（默认: %WifiName%）：
cls
echo.
echo.
echo        ┌—————————————┐
echo        │                          │
echo        │        输入Wifi密码      │
echo        │                          │
echo        └—————————————┘

set /p WifiKey=请输入WIFI热点的密码（必需，密码长度为 8~63 字符）：

netsh wlan set hostednetwork mode=allow ssid=%WifiName% key=%WifiKey% > nul
netsh wlan start hostednetwork > nul
if %errorlevel%==0 (
	cls
	color 2F
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点创建成功    │
	echo        │                          │
	echo        └—————————————┘
	echo 记得在控制面板 --^> 查看网络状态和任务 --^> 更改适配器设置 --^> 右键 “无线网络连接” --^> 属性 --^> 共享 --^> 勾选 “允许其他网络用户通过此计算机的 Internet 连接来连接” 然后选择 “无线网络连接 2” --^> 确定
	echo.
	goto end
) else (
	cls
	color CF
	echo.
	echo.
	echo        ┌—————————————┐
	echo        │                          │
	echo        │      Wifi热点创建失败    │
	echo        │                          │
	echo        └—————————————┘
	goto end
)

REM total lines: 535
REM total character include spaces: 14824
REM Not Bad :/
