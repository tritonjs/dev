/**
 * Escalate a normal user to "admin"
 *
 * @author Jared Allard <jaredallard@tritonjs.com>
 * @license MIT
 **/

'use strict';

const Db = require('../../backend/lib/db.js');
const CONFIG = require('../../config/config.json');

let dbctl = new Db(CONFIG);

const API_PUBLIC = process.argv[2].split(':')[0];
const API_SECRET = process.argv[2].split(':')[1];

if(!process.argv[1]) {
  console.log('ERR');
}

dbctl.searchClient('users', [
  ['api.public', '==', API_PUBLIC],
  ['api.secret', '==', API_SECRET]
])
.then(res => {
  dbctl.update('users', res.key, {
    role: 'admin'
  }).then(() => {
    console.log('OK');
  })
  .catch(err => {
    console.log('ERR');
  });
})
