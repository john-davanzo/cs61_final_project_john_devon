import mysql from 'mysql2/promise';
import { Client } from 'ssh2'; 
import fs from 'fs';
import path from 'path';

const key = fs.readFileSync(path.join(__dirname, '/movies_key.pem'));
// const key = fs.readFileSync(path.join(__dirname, '/devonstarr-gc-key.pem'));

// console.dir(key);

const sshTunnelMysqlConnection = async () => {
  return new Promise((resolve, reject) => {
    const sshConfig = {
      host: '3.228.68.244', //  54.82.152.133
      port: 22,
      username: 'ubuntu',
      privateKey: key
    };

    const tunnel = new Client();

    tunnel.on('ready', () => {
      tunnel.forwardOut(
        '127.0.0.1',
        12345,
        '127.0.0.1',
        3306,
        async (err, stream) => {
          if (err) reject(err);

          const connection = await mysql.createConnection({
            host: '127.0.0.1',
            user: 'root',
            password: 'bananasurprise53!',
            database: 'movies',
            stream: stream
          });

          resolve(connection);
        }
      );
    }).connect(sshConfig);
  });
};

// const connection = await sshTunnelMysqlConnection();

export default sshTunnelMysqlConnection;