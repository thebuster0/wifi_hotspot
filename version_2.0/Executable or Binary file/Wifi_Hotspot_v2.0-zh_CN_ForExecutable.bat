@ECHO OFF
@TITLE 无线网络共享工具

REM Used Bat2Exe to convert into a executable

set helpParameters=0
if "%1"=="/?" set helpParameters=1
if "%1"=="help" set helpParameters=1
if "%1"=="-help" set helpParameters=1
if %helpParameters% equ 1 goto showHelp

:pre-rollStage1
cls
echo 检查无线网卡是否支持虚拟WIFI热点...
set supported=0
netsh wlan show drive | find "支持的承载网络" | find "是"
if %errorlevel%==0 set supported=1

if %supported%==1 (
	set sup=是
) else (
	set sup=否
)
goto pre-rollStage2

:pre-rollStage2
if %sup%==否 goto netCardNotSupported
goto pre-rollStage3

:netCardNotSupported
color cf
echo 程序发现您的网卡不支持承载网络
set /p continue=继续吗？ [Y/n]: 
if %continue%=y goto pre-rollStage3
if %continue%=Y goto pre-rollStage3
if %continue%=n goto goto end
if %continue%=N goto goto end

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto netCardNotSupported

:pre-rollStage3
color 2f
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
goto menu

:menu
color 7
echo ┏━━━━━━━━━━┓
echo ┃无线网络共享工具v2.0┃
echo ┣━━━━━━━━━━┫
echo ┃ 1. 创建虚拟WIFI    ┃
echo ┃ 2. 启动虚拟WIFI    ┃
echo ┃ 3. 停止虚拟WIFI    ┃
echo ┃ 4. 查看WIFI状态    ┃
echo ┃ 5. 查看WIFI密码    ┃
echo ┃ 6. 更改WIFI设置    ┃
echo ┃ 7. 共享WIFI连接    ┃
echo ┃ 8. 退出            ┃
echo ┣━━━━━━━━━━┫
echo ┃ 支持承载网络：%sup%   ┃
echo ┃ 承载网络模式：%s2% ┃
echo ┃ 承载网络状态：%S% ┃
echo ┗━━━━━━━━━━┛
echo.
set /p mid=请选择 1-8 的命令，按Enter继续：
if "%mid%"=="1" goto create
if "%mid%"=="2" goto start
if "%mid%"=="3" goto stop
if "%mid%"=="4" goto viewConnect
if "%mid%"=="5" goto viewPWD
if "%mid%"=="6" goto changeSettings
if "%mid%"=="7" goto share
if "%mid%"=="8" goto end

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto menu
REM if you want to use this for other language, you should change below tags.
REM CP 936 = Chinese, 437 = English

:create
cls
if "%_name%"=="" set _name=WLAN_Hotspot
set /p _name=请输入WIFI热点的名字（默认: %_name%）：
set /p _password=请输入WIFI热点的密码（必需，密码长度为 8~63 字符）：
netsh wlan set hostednetwork mode=allow ssid=%_name% key=%_password%
if "%errorlevel%"=="0" echo 配置WIFI成功
netsh wlan start hostednetwork
if "%errorlevel%"=="0" (
	color 2f
	echo 虚拟WIFI热点已启动
) else (
	color cf
	echo 错误：尝试启动Wifi热点时出错
	echo ErrorLevel为：%errorlevel%
)

goto end

:start
color
cls
netsh wlan start hostednetwork
if %errorlevel%==0 (
	color 2f
	echo WIFI热点已启动
) else (
	color cf
	echo 错误：尝试启动Wifi热点时出错
	echo ErrorLevel为：%errorlevel%
)
goto end

:stop
color
cls
echo 正在停止热点
netsh wlan stop hostednetwork
echo 热点已停止
goto end

:viewConnect
color
cls
netsh wlan show hostednetwork
goto end

:viewPWD
color
cls
netsh wlan show hostednetwork setting=security
goto end

:changeSettings
color
cls

echo ┏━━━━━━━━━━┓
echo ┃    WIFI热点设置    ┃
echo ┣━━━━━━━━━━┫
echo ┃  1. 更改WIFI密码   ┃
echo ┃  2. 更改WIFI名称   ┃
echo ┃  3. 删除/禁用热点  ┃
echo ┃  4. 启用WIFI热点   ┃
echo ┃  5. 返回           ┃
echo ┗━━━━━━━━━━┛
set /p mid2=请选择 1-5 的命令，按Enter继续：
if "%mid2%"=="1" goto settingsS1
if "%mid2%"=="2" goto settingsS2
if "%mid2%"=="3" goto settingsS3
if "%mid2%"=="4" goto settingsS4
if "%mid2%"=="5" (
	cls
	goto menu
)

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto changeSettings

:settingsS1
color
cls
set /p @pwd=请输入新WIFI热点密码：
netsh wlan set hostednetwork key=%@pwd%
if %errorlevel%==0 (
	color 2f
	echo 更改完成
) else ( 
	color cf
	echo 错误：更改失败，未知错误
	echo Errorlevel: %errorlevel%
)
goto end

:settingsS2
cls
set /p @ssid=请输入新WIFI热点名称：
netsh wlan set hostednetwork ssid=%@ssid%
if %errorlevel%==0 (
	color 2f
	echo 更改完成
) else ( 
	color cf
	echo 错误：更改失败，未输入热点名称
	echo Errorlevel: %errorlevel%
)
goto end

:settingsS3
color
cls
set /p sure=你确定要删除/禁用热点？[Y/n]:
if %sure%==Y set sure1=1
if %sure%==y set sure1=1
if %sure%==N set sure1=0
if %sure%==n set sure1=0

if %sure1%==1 (
	goto settingsS3_y
) else (
	goto settingsS3_n
)

:settingsS3_y
netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
echo 承载网络已禁止

goto end

:settingsS3_n
cls
echo 已终止.
goto menu

:settingsS4
cls
echo 正在启用承载网络
netsh wlan set hostednetwork mode=allow
echo 已启用
goto end

:share
echo 请稍后，正在解压所需文件...
cls
echo -----BEGIN CERTIFICATE----- > "%~dp0\share.enc"
echo ZGltIHB1YiwgcHJ2LCBpZHgNCg0KSUNTU0NfREVGQVVMVCAgICAgICAgID0gMA0K >> "%~dp0\share.enc"
echo Q09OTkVDVElPTl9QVUJMSUMgICAgID0gMA0KQ09OTkVDVElPTl9QUklWQVRFICAg >> "%~dp0\share.enc"
echo ID0gMQ0KQ09OTkVDVElPTl9BTEwgICAgICAgID0gMg0KDQpzZXQgTmV0U2hhcmlu >> "%~dp0\share.enc"
echo Z01hbmFnZXIgPSBXc2NyaXB0LkNyZWF0ZU9iamVjdCgiSE5ldENmZy5ITmV0U2hh >> "%~dp0\share.enc"
echo cmUuMSIpDQoNCndzY3JpcHQuZWNobyAiTm8uICAgTmFtZSIgJiB2YkNSTEYgJiAi >> "%~dp0\share.enc"
echo LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t >> "%~dp0\share.enc"
echo LS0tLS0tLS0tLS0tLS0tLS0tIg0KaWR4ID0gMA0Kc2V0IENvbm5lY3Rpb25zID0g >> "%~dp0\share.enc"
echo TmV0U2hhcmluZ01hbmFnZXIuRW51bUV2ZXJ5Q29ubmVjdGlvbg0KZm9yIGVhY2gg >> "%~dp0\share.enc"
echo SXRlbSBpbiBDb25uZWN0aW9ucw0KCWlkeCA9IGlkeCArIDENCglzZXQgQ29ubmVj >> "%~dp0\share.enc"
echo dGlvbiA9IE5ldFNoYXJpbmdNYW5hZ2VyLklOZXRTaGFyaW5nQ29uZmlndXJhdGlv >> "%~dp0\share.enc"
echo bkZvcklOZXRDb25uZWN0aW9uKEl0ZW0pDQoJc2V0IFByb3BzID0gTmV0U2hhcmlu >> "%~dp0\share.enc"
echo Z01hbmFnZXIuTmV0Q29ubmVjdGlvblByb3BzKEl0ZW0pDQoJc3pNc2cgPSBDU3Ry >> "%~dp0\share.enc"
echo KGlkeCkgJiAiICAgICAiICYgUHJvcHMuTmFtZQ0KCXdzY3JpcHQuZWNobyBzek1z >> "%~dp0\share.enc"
echo Zw0KbmV4dA0Kd3NjcmlwdC5lY2hvICItLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t >> "%~dp0\share.enc"
echo LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0iDQp3c2Ny >> "%~dp0\share.enc"
echo aXB0LnN0ZG91dC53cml0ZSAiU2VsZWN0IHB1YmxpYyBjb25uZWN0aW9uKGZvciBp >> "%~dp0\share.enc"
echo bnRlcm5ldCBhY2Nlc3MpIE5vLjogIg0KcHViID0gY2ludCh3c2NyaXB0LnN0ZGlu >> "%~dp0\share.enc"
echo LnJlYWRsaW5lKQ0Kd3NjcmlwdC5zdGRvdXQud3JpdGUgIlNlbGVjdCBwcml2YXRl >> "%~dp0\share.enc"
echo IGNvbm5lY3Rpb24oZm9yIHNoYXJlIHVzZXJzKSBOby46ICINCnBydiA9IGNpbnQo >> "%~dp0\share.enc"
echo d3NjcmlwdC5zdGRpbi5yZWFkbGluZSkNCmlmIHB1YiA9IHBydiB0aGVuDQogIHdz >> "%~dp0\share.enc"
echo Y3JpcHQuZWNobyAiRXJyb3I6IFB1YmxpYyBjYW4ndCBiZSBzYW1lIGFzIHByaXZh >> "%~dp0\share.enc"
echo dGUhIg0KICB3c2NyaXB0LnF1aXQNCmVuZCBpZg0KDQppZHggPSAwDQpzZXQgQ29u >> "%~dp0\share.enc"
echo bmVjdGlvbnMgPSBOZXRTaGFyaW5nTWFuYWdlci5FbnVtRXZlcnlDb25uZWN0aW9u >> "%~dp0\share.enc"
echo DQpmb3IgZWFjaCBJdGVtIGluIENvbm5lY3Rpb25zDQoJaWR4ID0gaWR4ICsgMQ0K >> "%~dp0\share.enc"
echo CXNldCBDb25uZWN0aW9uID0gTmV0U2hhcmluZ01hbmFnZXIuSU5ldFNoYXJpbmdD >> "%~dp0\share.enc"
echo b25maWd1cmF0aW9uRm9ySU5ldENvbm5lY3Rpb24oSXRlbSkNCglzZXQgUHJvcHMg >> "%~dp0\share.enc"
echo PSBOZXRTaGFyaW5nTWFuYWdlci5OZXRDb25uZWN0aW9uUHJvcHMoSXRlbSkNCglp >> "%~dp0\share.enc"
echo ZiBpZHggPSBwcnYgdGhlbiBDb25uZWN0aW9uLkVuYWJsZVNoYXJpbmcgQ09OTkVD >> "%~dp0\share.enc"
echo VElPTl9QUklWQVRFDQoJaWYgaWR4ID0gcHViIHRoZW4gQ29ubmVjdGlvbi5FbmFi >> "%~dp0\share.enc"
echo bGVTaGFyaW5nIENPTk5FQ1RJT05fUFVCTElDDQpuZXh0DQo= >> "%~dp0\share.enc"
echo -----END CERTIFICATE----- >> "%~dp0\share.enc"

echo 正在解码...
certutil -decode "%~dp0\share.enc" "%~dp0\share.vbs" > nul
echo 解码完成，启动程序
cscript /nologo "%~dp0\share.vbs"

goto end

:end
set helpParameters=
set supported=
set sup=
set continue=
set stateOnOff=
set s2=
set S=
set mid=
set _name=
set _password=
set @pwd=
set @ssid=
set sure=
set sure1=
REM Reset errorLevel
color
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
if EXIST "%~dp0\share.vbs" ( del "%~dp0\share.vbs" )
if EXIST "%~dp0\share.enc" ( del "%~dp0\share.enc" )
pause
exit

:createMINI
echo 检查无线网卡是否支持虚拟WIFI热点...
set supported=0
netsh wlan show drive | find "支持的承载网络" | find "是"
if %errorlevel%==0 set supported=1
netsh wlan show drive | find "Hosted network supported" | find "Yes"
if %errorlevel%==0 set supported=1
if %supported% equ 1 (
  echo 您的网卡支持承载网络
  echo 请根据后续指令完成无线WIFI的配置。
) else (
  echo 发现您的网卡不支持承载网络，退出中
  goto end
)

cls
if "%_name%"=="" set _name=WLAN_Hotspot
set /p _name=请输入WIFI热点的名字（默认: %_name%）：
set /p _password=请输入WIFI热点的密码（必需，密码长度为 8~63 字符）：
netsh wlan set hostednetwork mode=allow ssid=%_name% key=%_password%
if "%errorlevel%"=="0" echo 配置WIFI成功
netsh wlan start hostednetwork
if "%errorlevel%"=="0" (
	color 2f
	echo 虚拟WIFI热点已启动
) else (
	color cf
	echo 错误：尝试启动Wifi热点时出错
	echo ErrorLevel为：%errorlevel%
)

goto end

:changeSettingsMINI
cls
echo ┏━━━━━━━━━━┓
echo ┃    WIFI热点设置    ┃
echo ┣━━━━━━━━━━┫
echo ┃  1. 更改WIFI密码   ┃
echo ┃  2. 更改WIFI名称   ┃
echo ┃  3. 删除/禁用热点  ┃
echo ┃  4. 启用WIFI热点   ┃
echo ┃  5. 返回           ┃
echo ┗━━━━━━━━━━┛
set /p mid2=请选择 1-5 的命令，按Enter继续：
if "%mid2%"=="1" goto settingsS1
if "%mid2%"=="2" goto settingsS2
if "%mid2%"=="3" goto settingsS3
if "%mid2%"=="4" goto settingsS4
if "%mid2%"=="5" goto pre-rollStage1

echo 错误：未知的选择
echo 按下任意键来重新选择
pause > nul
cls
goto changeSettings

:showHelp
echo	无线网络共享工具
echo	用法
echo        %~n0 [ create ^| start ^| stop ^| view ^| settings ^| help]
pause
exit /b 0

if "%1"=="create" goto create
if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="view" goto viewConnect
if "%1"=="settings" goto changeSettingsMINI