const express = require('express')
const path = require('path');
const app = express()
const port = 3000

global.count = 0

app.get('/', (req, res) => {
    global.count = global.count + 1
    if(global.count > 20 ){
        process.exit(1)
    }
    res.sendFile(path.join(__dirname, '/index.html'));
    console.log(`Request count ${global.count}`)
    setTimeout(() => {
        global.count = global.count - 1
    }, 200*global.count);

})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})
