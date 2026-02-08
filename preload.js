const { contextBridge, ipcRenderer } = require('electron');

// Expose a minimal safe API to renderer if needed later.
contextBridge.exposeInMainWorld('electronAPI', {
  // placeholder for future IPC methods
});
