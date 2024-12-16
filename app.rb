require 'bcrypt'

class App < Sinatra::Base


    def db
        return @db if @db

        @db = SQLite3::Database.new("db/todos.sqlite")
        @db.results_as_hash = true

        return @db
    end

    configure do
        enable :sessions
        set :session_secret, SecureRandom.hex(64)
    end

    get '/' do
        redirect "/todos"
    end

    get '/todos' do
        @todos = db.execute('SELECT * FROM todos')
        p @todos
        erb(:"index")
    end

    post '/todos' do
            #läs datan från formuläret
        name = params["name"]
        description = params["description"]
            #spara datan i databasen
        db.execute("INSERT INTO todos (name, description) VALUES(?,?)",
                    [name, description])
            #redirect '/todos'
        redirect("/todos")
    end

    get '/todos/:id/edit' do |id|
        #hämta info databas för id
        name = params["name"]
        description = params["description"]
        #fyll formuläret i edit.erb
        @todo = db.execute('SELECT * FROM todos WHERE id = ?', id.to_i).first

        erb(:'edit')
    end


    post '/todos/:id/update' do |id|
        name = params["name"]
        description = params["description"]

        db.execute('UPDATE todos SET name=?, description=? WHERE id = ?',
                    [name, description, id])

        redirect('/todos')
    end

    post '/todos/:id/delete' do |id|
        db.execute('DELETE FROM todos WHERE id = ?', id)

        redirect('/todos')
    end



    get '/:id' do | id |
        @todos = db.execute('SELECT *
                    FROM todos
                    WHERE ID = ?',
                    id).first
        erb(:"fruits/show")
    end

    post '/login' do
    end

    get '/logout' do
        p "/logout : logging out"
        #session.clear
        redirect '/'
    end

end
