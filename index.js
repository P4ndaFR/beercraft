const express = require('express')
const path = require('path');
const { Pool } = require("pg");
const cors = require("cors");
require("dotenv").config();

global.count = 0

const app = express();
app.use(cors());
app.use(express.json());


const pool = new Pool({
    user: process.env.POSTGRESQL_ADDON_USER,
    host: process.env.POSTGRESQL_ADDON_HOST,
    database: process.env.POSTGRESQL_ADDON_DB,
    password: process.env.POSTGRESQL_ADDON_PASSWORD,
    port: process.env.POSTGRESQL_ADDON_PORT,
    ssl: { rejectUnauthorized: false },
});

app.get('/', (req, res) => {
    global.count = global.count + 1
    res.sendFile(path.join(__dirname, '/index.html'));
    console.log(`Request count ${global.count}`)
    global.count = global.count - 1
})

app.get("/products", (req, res) => {
    res.sendFile(path.join(__dirname, '/products.html'));
})

app.get('/metrics', (req, res) => {
    res.send(`http_request ${global.count}`);
})


app.get("/api/products", async (req, res) => {
    try {
      const result = await pool.query("SELECT * FROM products");
      res.json(result.rows);
    } catch (err) {
      console.error("Erreur lors de la récupération des produits:", err);
      res.status(500).send("Erreur lors de la récupération des produits");
    }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Serveur backend démarré sur le port ${PORT}`);
});
