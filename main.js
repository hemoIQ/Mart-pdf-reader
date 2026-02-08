const { app, BrowserWindow } = require('electron');
const path = require('path');
const { checkForUpdates } = require('./updater');

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  // Load local index.html
  mainWindow.loadFile(path.join(__dirname, 'index.html'));

  // Check for updates after window is ready
  mainWindow.webContents.on('did-finish-load', () => {
    // Only check for updates in production
    if (!process.env.DEBUG) {
      checkForUpdates(mainWindow);
    }
  });
}

app.whenReady().then(() => {
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
