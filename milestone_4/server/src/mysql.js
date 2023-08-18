import mysql from 'mysql2/promise';
import { Client } from 'ssh2'; 
import fs from 'fs';
import path from 'path';

const key = fs.readFileSync(path.join(__dirname, '/devonstarr-gc-key.pem')); // absolute path to pem key for ssh'ing into EC2 instance

const sshTunnelMysqlConnection = async () => {
  return new Promise((resolve, reject) => {
    const sshConfig = {
      host: '34.207.136.197', // public ip of EC2 instance
      port: 22, // ssh port
      username: 'ubuntu', // default username for EC2 instances
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
            host: '127.0.0.1', // ip of database server within the ssh tunnel, i.e. localhost
            user: 'root', // user name for database server
            password: 'bananasurprise53!', // password for database server
            database: 'movies', // default database to use
            stream: stream
          });

          resolve(connection);
        }
      );
    }).connect(sshConfig);
  });
};

export default sshTunnelMysqlConnection;