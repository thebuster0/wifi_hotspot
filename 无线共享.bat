@ECHO OFF
@TITLE �������繲����

REM MIT License, owned by thebuster000@gmail.com. Free to all

set helpParameters=0
if "%1"=="/?" set helpParameters=1
if "%1"=="help" set helpParameters=1
if "%1"=="-help" set helpParameters=1
if %helpParameters% equ 1 (
	echo �������繲����
	echo �÷�
		echo    %~n0 [ create ^| start ^| stop ^| view ^| settings ^| help]
	exit /b 0
)

net session >nul 2>&1
if not "%errorLevel%" == "0" (
	echo ��������Ҫ����ԱȨ�ޣ����Զ��л�������ԱȨ�ޣ���������û�Ȩ�޿��ƶԻ���
	echo �������ǡ���ť�Լ������У�����������������
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin.vbs"
	
	"%temp%\getadmin.vbs"
	exit /b 2
)

if "%1"=="create" goto createMINI
if "%1"=="start" goto startMINI
if "%1"=="stop" goto stopMINI
if "%1"=="view" goto viewMINI
if "%1"=="settings" goto changeSettingsMINI

:pre-roll
cls
echo ������������Ƿ�֧������WIFI�ȵ�...
set supported=0
netsh wlan show drive | find "֧�ֵĳ�������" | find "��"
if %errorlevel%==0 set supported=1

if %supported%==1 (
	set sup=��
) else (
	set sup=��
)

set stateOnOff=0
netsh wlan show hostednetwork | find "״̬" | find "������"
if %errorlevel%==0 set stateOnOff=1
if %stateOnOff%==1 (
	set S=����
) else (
	set S=�ر�
)

set hostednetworkMode=0
netsh wlan show hostednetwork | find "ģʽ" | find "������"
if %errorlevel%==0 (
	set s2=����
) else (
	set s2=����
)
cls
:menu
echo ������������������������
echo ���������繲����v1.0��
echo �ǩ���������������������
echo �� 1. ��������WIFI    ��
echo �� 2. ��������WIFI    ��
echo �� 3. ֹͣ����WIFI    ��
echo �� 4. �鿴WIFI״̬    ��
echo �� 5. �鿴WIFI����    ��
echo �� 6. ����WIFI����    ��
echo �� 7. ����WIFI����    ��
echo �� 8. �˳�            ��
echo �ǩ���������������������
echo �� ֧�ֳ������磺%sup%   ��
echo �� ��������ģʽ��%s2% ��
echo �� ��������״̬��%S% ��
echo ������������������������
echo.
set /p mid=��ѡ�� 1-8 �������Enter������
if "%mid%"=="1" goto create
if "%mid%"=="2" goto start
if "%mid%"=="3" goto stop
if "%mid%"=="4" goto viewConnect
if "%mid%"=="5" goto viewPWD
if "%mid%"=="6" goto changeSettings
if "%mid%"=="7" goto share
if "%mid%"=="8" goto end
echo ����ѡ���������Ч�������ԡ�
goto menu

:create
cls
if "%_name%"=="" set _name=WLAN_Hotspot
set /p _name=������WIFI�ȵ�����֣�Ĭ��: %_name%����
set /p _password=������WIFI�ȵ�����루���裬���볤��Ϊ 8~63 �ַ�����
netsh wlan set hostednetwork mode=allow ssid=%_name% key=%_password%
if "%errorlevel%"=="0" echo ����WIFI�ɹ�
netsh wlan start hostednetwork
if "%errorlevel%"=="0" (
	echo ����WIFI�ȵ�������
) else (
	echo ���󣺳�������Wifi�ȵ�ʱ����
	echo ErrorLevelΪ��%errorlevel%
)

goto end

:start
cls
netsh wlan start hostednetwork
echo WIFI�ȵ�������
goto end

:stop
cls
echo ����ֹͣ�ȵ�
netsh wlan stop hostednetwork
echo �ȵ���ֹͣ
goto end

:viewConnect
cls
netsh wlan show hostednetwork
goto end

:viewPWD
cls
netsh wlan show hostednetwork setting=security
goto end

:changeSettings
cls
net session >nul 2>&1
if not "%errorLevel%" == "0" (
	echo ��������Ҫ����ԱȨ�ޣ����Զ��л�������ԱȨ�ޣ���������û�Ȩ�޿��ƶԻ���
	echo �������ǡ���ť�Լ������У�����������������
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\getadmin.vbs"
	
	"%temp%\getadmin.vbs"
	exit /b 2
)
echo ������������������������
echo ��    WIFI�ȵ�����    ��
echo �ǩ���������������������
echo ��  1. ����WIFI����   ��
echo ��  2. ����WIFI����   ��
echo ��  3. ɾ��/�����ȵ�  ��
echo ��  4. ����WIFI�ȵ�   ��
echo ��  5. ����           ��
echo ������������������������
set /p mid2=��ѡ�� 1-4 �������Enter������
if "%mid2%"=="1" goto settingsS1
if "%mid2%"=="2" goto settingsS2
if "%mid2%"=="3" goto settingsS3
if "%mid2%"=="4" goto settingsS4
if "%mid2%"=="5" goto menu

:settingsS1
cls
set /p @pwd=��������WIFI�ȵ����룺
netsh wlan set hostednetwork key=%@pwd%
if %errorlevel%==0 (
	echo �������
) else ( 
	echo ���󣺸���ʧ�ܣ�δ֪����
	echo Errorlevel: %errorlevel%
)
goto end

:settingsS2
cls
set /p @ssid=��������WIFI�ȵ����ƣ�
netsh wlan set hostednetwork ssid=%@ssid%
if %errorlevel%==0 (
	echo �������
) else ( 
	echo ���󣺸���ʧ�ܣ�δ֪����
	echo Errorlevel: %errorlevel%
)
goto end

:settingsS3
cls
set /p sure=��ȷ��Ҫɾ��/�����ȵ㣿[Y/n]:
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
echo ���������ѽ�ֹ

goto end

:settingsS3_n
cls
echo ����ֹ.
goto menu

:settingsS4
cls
echo �������ó�������
netsh wlan set hostednetwork mode=allow
echo ������
goto end

:share
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

certutil -decode "%~dp0\share.enc" "%~dp0\share.vbs"
cscript /nologo "%~dp0\share.vbs"

goto end

:end
set _name=
set _password=
set mid=
set mid2=
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
if EXIST "%~dp0\share.vbs" ( del "%~dp0\share.vbs" )
if EXIST "%~dp0\share.enc" ( del "%~dp0\share.enc" )
pause
exit

:createMINI
REM if you want to use this for other language, you should change below tags.
REM CP 936 = Chinese, 437 = English
echo ������������Ƿ�֧������WIFI�ȵ�...
set supported=0
netsh wlan show drive | find "֧�ֵĳ�������" | find "��"
if %errorlevel%==0 set supported=1
netsh wlan show drive | find "Hosted network supported" | find "Yes"
if %errorlevel%==0 set supported=1
if %supported% equ 1 (
  echo ��������֧�ֳ�������
  echo ����ݺ���ָ���������WIFI�����á�
) else (
  echo ��������������֧�ֳ������磬�˳���
  goto end
)

if "%_name%"=="" set _name=wlan
set /p _name=������WIFI�ȵ�����֣�Ĭ��: %_name%����
set /p _password=������WIFI�ȵ�����루���裬���볤��Ϊ 8~63 �ַ�����
netsh wlan set hostednetwork mode=allow ssid=%_name% key=%_password%
if "%errorlevel%"=="0" echo ����WIFI�ɹ���
netsh wlan start hostednetwork
if "%errorlevel%"=="0" (
  echo ����WIFI�ɹ�
  echo �����Ҫ������ֻ��������������������������в�ѡ����WIFI���ӡ�
) else (
  echo ��������WIFI�ȵ�ʧ�ܡ�
)
goto end

:startMINI
netsh wlan start hostednetwork
echo �ȵ�������
goto end

:stopMINI
netsh wlan stop hostednetwork
echo �ȵ��ѹر�
goto end

:viewMINI
netsh wlan show hostednetwork
goto end

:changeSettingsMINI
cls
echo ������������������������
echo ��    WIFI�ȵ�����    ��
echo �ǩ���������������������
echo ��  1. ����WIFI����   ��
echo ��  2. ����WIFI����   ��
echo ��  3. ɾ��/�����ȵ�  ��
echo ��  4. ����WIFI�ȵ�   ��
echo ��  5. ����           ��
echo ������������������������
set /p mid2=��ѡ�� 1-5 �������Enter������
if "%mid2%"=="1" goto settingsS1
if "%mid2%"=="2" goto settingsS2
if "%mid2%"=="3" goto settingsS3
if "%mid2%"=="4" goto settingsS4
if "%mid2%"=="5" goto pre-roll