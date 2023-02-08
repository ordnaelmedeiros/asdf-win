const express = require("express");
const app = express();

app.use(express.json());

app.get("/hello", (req, res) => {
    res.status(200).json("Hello");
});

app.listen(3000, () => console.log("API Server is running...: http://localhost:3000/hello"));
