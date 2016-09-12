### ESPN Cricket Live Score Example using RabbitMQ. [Publisher/Producer Microservice]

In this microservice, we (admin) actually adds live match record (score) into
the database and immediately we also publish that score to another microservice
[https://github.com/mechanicles/espn_cricinfo_frontend](https://github.com/mechanicles/espn_cricinfo_frontend).

This microservice [https://github.com/mechanicles/espn_cricinfo_frontend](https://github.com/mechanicles/espn_cricinfo_frontend) acts as
a subscriber to our system. Users will use this microservice to get the real time
match updates on their browser.

#### Setup

- Install [RabbitMQ](https://www.rabbitmq.com/download.html) and run it in
  background.
- Create & migrate database using Rails commands.

#### Demo

- Publisher Microservice - [https://espn-cricinfo.herokuapp.com/](https://espn-cricinfo.herokuapp.com/)
- Subscriber Microservice - [https://espn-cricinfo-frontend.herokuapp.com/](https://espn-cricinfo-frontend.herokuapp.com/)
