const express = require('express');
const app = express();
const fs = require("fs");
const os = require("os");
const osUtils = require('os-utils');
const exec = require('child_process').exec;
const si = require('systeminformation');
// Importing the required modules
const WebSocketServer = require('ws');

// Creating a new websocket server
const wss = new WebSocketServer.Server({ port: 8080 })
const runtimeCache = {};
// Set runtime cache cpu usage as a list (first is the last removed)
runtimeCache.cpuUsage = [];
runtimeCache.cpuTemp = [];
runtimeCache.processes = 0;
runtimeCache.wsClients = [];

const toClient = (client, tag, data) => {
   client.send(JSON.stringify({
      tag,
      data
   }));
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
}, 500);



// Creating connection using websocket
wss.on("connection", ws => {
   // Add client to the list
   runtimeCache.wsClients.push(ws);
   console.log("new client connected");
   // sending message
   ws.on("message", data => {
      console.log(`Client has sent us: ${data}`)
   });
   // handling what to do when clients disconnects from server
   ws.on("close", () => {
      console.log("the client has connected");
   });
   // handling client connection error
   ws.onerror = function () {
      console.log("Some Error occurred")
   }
});
console.log("The WebSocket server is running on port 8080");