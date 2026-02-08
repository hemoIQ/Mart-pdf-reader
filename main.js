const { app, BrowserWindow } = require('electron');
const path = require('path');
const fs = require('fs');
const { checkForUpdates } = require('./updater');

let mainWindow;

// Create books directory if it doesn't exist
const booksDir = path.join(app.getPath('userData'), 'books');
if (!fs.existsSync(booksDir)) {
  fs.mkdirSync(booksDir, { recursive: true });
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    show: false, // Don't show until ready
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false
    }
  });

  // Load local index.html
  mainWindow.loadFile(path.join(__dirname, 'index.html'));

  // Show window when ready to avoid flickering
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  // Check for updates after window is ready
  mainWindow.webContents.on('did-finish-load', () => {
    // Only check for updates in production and when online
    if (!process.env.DEBUG && navigator.onLine) {
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
