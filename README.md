## ESPN Cricket Live Score Example using RabbitMQ. [Publisher/Producer Microservice]

In this app/microservice, we (admin) actually adds cricket match records (score) into the database and later we
publish those data to another [microservice](https://github.com/mechanicles/espn_cricinfo_frontend).

This [microservice](https://github.com/mechanicles/espn_cricinfo_frontend) acts as
a subscriber to our system. Users will use this microservice to get the real
time data updates on their browser.
