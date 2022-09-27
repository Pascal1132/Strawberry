const express = require('express');
const app = express();
const fs = require("fs");
const os = require("os");
const osUtils = require('os-utils');
const exec = require('child_process').exec;
const si = require('systeminformation');
// Importing the required modules
const WebSocketServer = require('ws');
const MessageHandler = require('./message_handler');
const pm2Instance = require('./pm2');

// Creating a new websocket server
const wss = new WebSocketServer.Server({ port: 8080 })
const runtimeCache = {};
// Set runtime cache cpu usage as a list (first is the last removed)
runtimeCache.cpuUsage = [];
runtimeCache.cpuTemp = [];
runtimeCache.processes = 0;
runtimeCache.wsClients = [];
runtimeCache.services = [];

const toClient = (client, tag, data) => {
   client.send(JSON.stringify({
      tag,
      data
   }));
}

const fetchServices = () => {
   return new Promise((resolve, reject) => {
      exec('systemctl list-units --type=service', (err, stdout, stderr) => {
         if (err) {
            reject(err);
         } else {
            runtimeCache.services = stdout.split(os.EOL).slice(1).map((line) => {
               const splitted = line.split(/\s+/);
               // if splitted 2 or 3 is undefined, then it's not a service
               if (splitted[2] === undefined || splitted[3] === undefined) {
                  return null;
               }
               return {
                  name: splitted[1],
                  load: splitted[2],
                  active: splitted[3],
                  description: splitted[4]
               };
            });
            // Remove all values after the first null
            const index = runtimeCache.services.indexOf(null);
            if (index > -1) {
               runtimeCache.services = runtimeCache.services.slice(0, index);
            }
            resolve(runtimeCache.services);
         }
      });
   });
}

const sentToClient = () => {
   osUtils.cpuUsage((v) => {
      runtimeCache.cpuUsage.push(Math.round(v * 100) / 100);
      if (runtimeCache.cpuUsage.length > 30) {
         runtimeCache.cpuUsage.shift();
      }
      si.cpuTemperature(({ main }) => {
         runtimeCache.cpuTemp.push(Math.round(main * 100) / 100);
         if (runtimeCache.cpuTemp.length > 30) {
            runtimeCache.cpuTemp.shift();
         }
         exec('ps -e | wc -l', (error, stdout, stderr) => {
            runtimeCache.processes = parseInt(stdout);
            const { cpuUsage, cpuTemp, processes } = runtimeCache;
            wss.clients.forEach((client) => {
               toClient(client, 'cpuInfos', { cpuUsage, cpuTemp, processes });
            });
         });
      });
   });
}
// Timer each 5 seconds to get the CPU usage
setInterval(function () {
   sentToClient();
   pm2Instance.list().then((list) => {
      wss.clients.forEach((client) => {
         toClient(client, 'pm2Infos', list);
      });
   });
}, 500);

// DISABLED FOR NOW
/*setInterval(async function () {
   fetchServices();
   for (let i = 0; i < runtimeCache.wsClients.length; i++) {
      const client = runtimeCache.wsClients[i];
      toClient(client, 'services', runtimeCache.services);
   }
}, 5000);*/

// Creating connection using websocket
wss.on("connection", ws => {
   // Add client to the list
   runtimeCache.wsClients.push(ws);
   console.log("new client connected");
   // Send the current data to the client
   toClient(ws, 'welcome', { message: 'Welcome to the server' });
   // sending message
   ws.on("message", async data => {
      console.log(`Client has sent us: ${data}`);
      console.log(await MessageHandler.handle(data, ws));
   });
   // handling what to do when clients disconnects from server
   ws.on("close", () => {
      console.log("the client has disconnected");
   });
   // handling client connection error
   ws.onerror = function () {
      console.log("Some Error occurred")
   }
});
console.log("The WebSocket server is running on port 8080");