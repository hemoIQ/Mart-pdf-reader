@echo off
REM Simple runner: change to script folder and run the app
cd /d "%~dp0"
echo Starting Smart PDF Reader (Electron)...
npm run start
