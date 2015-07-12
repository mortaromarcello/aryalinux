#!/bin/bash

cp -v ../map.php /var/www/map.php
mysql -uroot -ppassword@123 < ../database.sql
cd client
python client.py

