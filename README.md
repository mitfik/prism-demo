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
