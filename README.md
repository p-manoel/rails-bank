# Rails Bank

Rails Bank is a simple, secure, and efficient ATM system. It uses Ruby on Rails as the backend, providing a robust framework for web development.

## Dependencies

- Ruby 2.3.8
- Rails 4.0.13
- SQLite 1.3.9

## Setup

1. Clone the repository
2. Install Ruby (version 2.3.8) if not already installed.
3. Install Bundler to manage dependencies: `gem install bundler`
4. Install Rails (version 4.0.13) if not already installed: `gem install rails -v 4.0.13`
5. Install SQLite (version 1.3.9) if not already installed.
6. Run `bundle install` to install all the required gems and dependencies.
7. Set up the database: `rake db:migrate`
8. Start the server: `rails server`
9. Visit `localhost:3000` on your browser to access the application.

## Features

- User registration and authentication (Devise)
- ATM functionality: deposit, withdrawal, and balance inquiries
- Transaction history
