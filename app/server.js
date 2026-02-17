const express = require("express");
const sql = require("mssql");

const app = express();
const port = process.env.PORT || 3000;

const dbConfig = {
  server: process.env.DB_SERVER,    
  database: process.env.DB_NAME,     
  user: process.env.DB_USER,         
  password: process.env.DB_PASSWORD, 
  options: { encrypt: true, trustServerCertificate: false }
};

app.get("/", async (_req, res) => {
  try {
    const pool = await sql.connect(dbConfig);

    const result = await pool.request().query(`
      SELECT TOP 1 QuoteText, Author
      FROM dbo.Quotes
      ORDER BY NEWID();
    `);

    const row = result.recordset?.[0];
    if (!row) return res.status(404).send("No quotes found.");

    res.send(`
      <html>
        <head><title>Degreed Quotes</title></head>
        <body style="font-family: Arial; padding: 30px;">
          <h2>Degreed Web Apps - Random Quote</h2>
          <p style="font-size: 20px;">"${row.QuoteText}"</p>
          <p><b>- ${row.Author}</b></p>
        </body>
      </html>
    `);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching quote.");
  }
});

app.get("/health", (_req, res) => res.status(200).send("OK"));

app.listen(port, () => console.log(`App running on port ${port}`));
