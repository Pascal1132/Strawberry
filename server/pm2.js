// Create js class for pm2 monitoring module

const pm2 = require('pm2');

class PM2 {
    constructor() {
        this.pm2 = pm2;
        this.pm2.connect((err) => {
            if (err) {
                console.error(err);
                process.exit(2);
            }
        });
    }

    list() {
        return new Promise((resolve, reject) => {
            this.pm2.list((err, list) => {
                if (err) {
                    reject(err);
                } else {
                    // keep only the name and the status
                    resolve(list.map((process) => {
                        return {
                            pid: process.pid,
                            name: process.name,
                            status: process.pm2_env.status,
                            exec_mode: process.pm2_env.exec_mode,
                            instances: process.pm2_env.instances,
                            monit: {...process.monit, memory: parseInt(process.monit.memory / 1024 / 1024)},
                        };
                    }));
                }
            });
        });
    }

    async restartProcess(name) {
        try {
            this.pm2.restart(name);
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }

    async stopProcess(name) {
        try {
            this.pm2.stop(name);
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }

    async startProcess(name) {
        try {
            this.pm2.start(name);
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }

    async deleteProcess(name) {
        try {
            this.pm2.delete(name);
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }

    async save() {
        try {
            this.pm2.dump();
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }

    async resurrect() {
        try {
            this.pm2.resurrect();
            return {success: true};
        } catch (e) {
            return {error: e};
        }
    }
}
const pm2Instance = new PM2();
module.exports = pm2Instance;