const { autoUpdater } = require('electron-updater');
const { dialog } = require('electron');

// Configure auto-updater
autoUpdater.autoDownload = false;
autoUpdater.autoInstallOnAppQuit = true;

// Check for updates
function checkForUpdates(mainWindow) {
  autoUpdater.checkForUpdates();

  // When update is available
  autoUpdater.on('update-available', (info) => {
    dialog.showMessageBox(mainWindow, {
      type: 'info',
      title: 'تحديث متوفر',
      message: `إصدار جديد ${info.version} متوفر. هل تريد تحميله الآن؟`,
      buttons: ['نعم', 'لاحقاً']
    }).then((result) => {
      if (result.response === 0) {
        autoUpdater.downloadUpdate();
      }
    });
  });

  // When update is not available
  autoUpdater.on('update-not-available', () => {
    console.log('التطبيق محدث بالفعل');
  });

  // Download progress
  autoUpdater.on('download-progress', (progressObj) => {
    let message = `سرعة التحميل: ${progressObj.bytesPerSecond}`;
    message += ` - تم تحميل ${progressObj.percent}%`;
    message += ` (${progressObj.transferred}/${progressObj.total})`;
    console.log(message);
  });

  // When update is downloaded
  autoUpdater.on('update-downloaded', () => {
    dialog.showMessageBox(mainWindow, {
      type: 'info',
      title: 'التحديث جاهز',
      message: 'تم تحميل التحديث. سيتم تثبيته عند إعادة تشغيل التطبيق.',
      buttons: ['إعادة التشغيل الآن', 'لاحقاً']
    }).then((result) => {
      if (result.response === 0) {
        autoUpdater.quitAndInstall();
      }
    });
  });

  // Error handling
  autoUpdater.on('error', (error) => {
    console.error('خطأ في التحديث:', error);
  });
}

module.exports = { checkForUpdates };
