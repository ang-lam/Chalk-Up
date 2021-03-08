# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app [used sinatra to create application]
- [x] Use ActiveRecord for storing information in a database [used ActiveRecord for db]
- [x] Include more than one model class (e.g. User, Post, Category) [have 3 models - user, workout, exercise]
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts) [have two has_many relationship - user has many workouts and workouts has many exercises]
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User) [have two belongs_to relationship - workout belongs_to user and exercise belongs_to workout]
- [x] Include user accounts with unique login attribute (username or email) [signup does not allow new user to create an account if email or username already exists in db]
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying [workout and exercise can be CRUD through workouts_controller]
- [x] Ensure that users can't modify content created by other users [erb files only display if user is logged in and the workout belongs to the user]
- [x] Include user input validations [ensured date entry by using calendar html, added validations for no missing fields, added validation for only accepting integer for weights]
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new) [used sinatra-flash to display flash messages for errors]
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message