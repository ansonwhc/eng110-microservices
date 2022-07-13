const express = require('express');
const redis = require('redis');

const app = express();
const client = redis.createClient({
    // host: 'https://someweb.com'  // usually
    host: 'redis-server', // we can use the docker service name here when using docker 
    port: 6379  // default redis port
});
client.set('visits', 0);

app.get('/', (req, res) => {
    client.get('visits', (err, visits) => {
        res.send('Number of visits is ' + visits);
        client.set('visits', parseInt(visits) + 1);
    });
});

app.listen(3000, () => {
    console.log('Linstening on port 3000');
});