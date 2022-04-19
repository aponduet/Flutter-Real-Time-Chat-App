


const express = require('express');
const cors = require('cors');
const app = express();
const http = require('http');
const server = http.createServer(app);
const io = require("socket.io")(server);

require('dotenv').config();
const port = process.env.PORT || 5000;


app.use(express.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send( 'Hello Sohel');
});

io.on('connection', (socket) => {
  console.log(`${socket.id} has joined!!`);
  
  socket.on('message', (info)=>{
    console.log(info);
    io.sockets.emit('reply', info );
    // socket.broadcast.emit ব্যবহার করলে যে ব্যক্তি মেসেজ পাঠায় সে ব্যাতিত অন্য সবাই মেসেজ পাবে।
    // io.sockets.emit ব্যবহার করলে নিজে সহ অন্য সবাই মেসেজ পাবে।
  });
  

});

server.listen(port, "0.0.0.0", () => {
  console.log(`Server Listening on Port ${port}`);
});