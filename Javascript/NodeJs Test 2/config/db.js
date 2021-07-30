const { MongoClient } = require("mongodb");

const client = new MongoClient(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
});

let messagesDB = null;

async function connectDB() {
    try {
        await client.connect();
        const database = client.db("ChatApp");
        messagesDB = database.collection("Messages");
        console.log("DB Connected");
    } catch (err) {
        console.log(err);
    }
}

async function addMessage(MSG) {
    try {
        const result = await messagesDB.insertOne(MSG);
    } catch (error) {
        console.log(error);
    }
}

async function readAllMessages() {
    try {
        await connectDB();
        const result = await messagesDB.find().toArray();
        console.log("Messages loaded from DB")
        return result;
    } catch (error) {
        console.log(error);
    }
}

module.exports = { addMessage, readAllMessages };
