#!/bin/bash

call rails generate scaffold Bid category:integer available:boolean user:references purchase:references --no-migration --force

call rails generate scaffold BusinessTag business:references tag:references --no-migration --force

call rails generate scaffold Business user:references company_name:string phone_number:string biography:text website:string --no-migration --force

call rails generate scaffold Estimate summary:string description:text price:decimal duration:decimal inspection_required:boolean quote:references --no-migration --force

call rails generate scaffold ProjectMetaDatum project:references start_date:date cut_off_date:date entry_required:boolean can_disturb:boolean show_address:boolean providing_materials:boolean --no-migration --force

call rails generate scaffold ProjectTag project:references tag:references --no-migration --force

call rails generate scaffold Project width:decimal length:decimal height:decimal state:integer summary:string description:text additional_comments:text user:references --no-migration --force

call rails generate scaffold Purchase transaction:references user:references quantity:integer --no-migration --force

call rails generate scaffold Quote project:references business:references bid:references --no-migration --force

call rails generate scaffold Tag name:string --no-migration --force

call rails generate scaffold User email:string password:string salt:string postal_code:string username:string country_alpha2:string --no-migration --force
