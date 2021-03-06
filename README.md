PRISM - companies database
=======

Configuration
-----------

To set configuration file you can reuse template file which is available in
*config/database.yml.template*. PRISM will look for config file by default in
*config/database.yml* if you want to change that you can specify
*ENV["CONFIG_FILE"]* to something else.

Copy config/database.yml.template to config/database.yml

     cp config/database.yml.template to config/database.yml

How to run tests
-----------

    ruby tests/prism_test.rb

How to use API
-----------

To interact with the application you will need [cUrl](http://en.wikipedia.org/wiki/CURL) application.

If you want to see also http headers use *-i* with curl like:

  curl -i ....

### Fetch all companies

    curl http://prism-demo.herokuapp.com/companies

### Create new company

    curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"name": "NASA", "address": "Wojska Polskiego", "city": "Szczecin", "country": "Poland" }' http://prism-demo.herokuapp.com/company

    curl -i -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"name": "NASA", "address": "Wojska Polskiego", "city": "kazi", "country": "USA", "owners":[{"full_name":"Robert"}, {"full_name":"Adam"}], "phone_number": "1241241241" }' http://prism-demo.herokuapp.com/company

### Fetch company by ID=1

    curl http://prism-demo.herokuapp.com/company/1

### Update company with ID=1

    curl -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "New name", "address": "Wojska Polskiego", "city": "kazi", "country": "Niemcy"}' http://prism-demo.herokuapp.com/company/1

    curl -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d '{"name": "NASA", "address": "Wojska Polskiego", "city": "kazi", "country": "USA", "owners":[{"full_name":"Robert"}, {"full_name":"Adam"}], "phone_number": "1241241241" }' http://prism-demo.herokuapp.com/company/1

### Upload pdf for the owner (with ID=3) of the company (with ID=1)

    curl -i -H "Accept: application/json" -X PUT -F "file=@test.pdf" http://prism-demo.herokuapp.com/company/1/3/upload

### Fetch owner pdf from company ID=1 and owner ID=1

    curl -i http://prism-demo.herokuapp.com/company/1/owner/1 -o 1.pdf
