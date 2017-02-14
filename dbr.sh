#!/bin/bash

if [ "$#" -eq 1 ]
then
	 rake db:drop RAILS_ENV=test
     rake db:create RAILS_ENV=test
     rake db:migrate RAILS_ENV=test
     rake db:seed RAILS_ENV=test
 else
	 rake db:drop RAILS_ENV=development
     rake db:create RAILS_ENV=development
     rake db:migrate RAILS_ENV=development
     rake db:seed RAILS_ENV=development
fi

