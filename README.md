# wsb_praca_dyplomowa
Dariusz Zyzik 

WSB Chorzow grupa2 online

Kierunek "Tester oprogramowania"
# A simple Node booking form for testing RESTful web services.

API is on GIT Hub  https://github.com/mwinteringham/restful-booker

API is running on https://restful-booker.herokuapp.com/
or install on local machine.

API details can be found on the publically deployed version of Restful-Booker: https://restful-booker.herokuapp.com/

API details documentation: https://restful-booker.herokuapp.com/apidoc/index.html

# Requirements
- Docker 17.09.0
- Docker Compose 1.16.1

# Installation
- Ensure mongo is up and running by executing mongod in your terminal
- Clone the repo
- Navigate into the restful-booker root folder
- Run npm install
- Run npm start

## Or you can run this via Docker:

- Clone the repo https://github.com/mwinteringham/restful-booker
- In the restful-booker root folder:
- Run docker-compose build
- Run docker-compose up
- APIs are exposed on http://localhost:3001

## To run tests use command:
python3 -m robot booker.robot
