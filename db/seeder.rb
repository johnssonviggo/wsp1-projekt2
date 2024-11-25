require 'sqlite3'
require 'bcrypt'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
    p "doit"
  end


  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
    db.execute('DROP TABLE IF EXISTS users')
  end


  def self.create_tables
  db.execute('CREATE TABLE todos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT)')

  db.execute('CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL,
              password TEXT NOT NULL)')
end

def self.populate_tables
  password_hashed = BCrypt::Password.create("123")
  p "Storing hashed version of password to db. Clear text never saved. #{password_hashed}"

  db.execute('INSERT INTO todos (name, description) VALUES ("Äpple", "En rund frukt som finns i många olika färger.")')

  db.execute('INSERT INTO users (username, password) VALUES (?, ?)', ["Viggo", password_hashed])
end

private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/todos.sqlite')
    @db.results_as_hash = true
    @db
  end
end

Seeder.seed!
