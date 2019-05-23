67-272 Application Design and Development: The Baking Factory
---
This is my solution to a bakery web app for 67-272 Application Design and Development. Requirements for the project can be found on the [67-272 course site](http://67272.cmuis.net/projects). Everything was designed and implemented by me.

**The web app can be found on Heroku [here](https://calm-sea-19596.herokuapp.com).** 

****Set up****

*Make sure to have Ruby and Rails 5 installed*

To set this up, clone this repository, run the `bundle install` command to ensure you have all the needed gems and then create the database with `rake db:migrate`.  If you want to populate the system with fictitious, but somewhat realistic data, you can run the `rake db:populate` command.  The populate script will create:
- 120 customers
- over 600 orders
- a menu of 5 types of breads, 3 varieties of muffins and 1 type of pastry

All users in the system have a password of 'secret'. In terms of employee-type users there are two admins -- Alex (username: 'alex') and Mark (username: 'mark') -- and a shipper (username: 'shipper') and a baker (username: 'baker'). All customers have a username which is 'user' with a sequential set of numbers concatentated. (user1 - user120 should exist for you to log in as and experiment.) Feel free to create your own accounts as well.  

*****Built with*****
[Ruby on Rails](https://rubyonrails.org/) - web framework 

[Materialize](https://materializecss.com/) - CSS framework
