module.exports = {
    API_PORT: 4000,
    USER: "hepeikukkdnsus",
    HOST: "ec2-54-175-117-212.compute-1.amazonaws.com",
    DATABASE: "d5iducvgnj372p",
    PASS: "e88ec85f78be52ebdbb25c90bcb627e9d3cac30f660b52fa93cdab79d78e438b",
    PORTBD:  5432,
    SECRET_KEY:  "sgc_api",

    application: {
        cors: {
            server: [
                {
                    origin: "*", //servidor que deseas "localhost:3000" que consuma o (*) en caso que sea acceso libre
                    credentials: true
                }
            ]
        }

    }
}