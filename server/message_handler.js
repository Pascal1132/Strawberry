const pm2Instance = require('./pm2');

module.exports = class MessageHandler {
    static async handle(message, wsClient) {
        const {tag, data} = JSON.parse(message);
        switch (tag) {
            case 'restartPm2Process':
                return await pm2Instance.restartProcess(data);
            case 'resurrectPm2':
                return await pm2Instance.resurrect();
            case 'stopPm2Process':
                return await pm2Instance.stopProcess(data);
            case 'startPm2Process':
                return await pm2Instance.startProcess(data);
            case 'deletePm2Process':
                return await pm2Instance.deleteProcess(data);
            case 'savePm2':
                return await pm2Instance.save();
                default:
                return {error: 'Unknown tag'};
        }
    }
}