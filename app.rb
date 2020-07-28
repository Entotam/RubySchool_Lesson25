require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date = params[:date]
	@barber_choise = params[:barber_choise]
	@color = params[:color]

	hh = {
		:username => "Введите имя",
		:phone => "Введите телефон",
		:date => "Введите дату"
		}

	is_hh_empty? hh

	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@message_contacts = params[:message_contacts]

	file = File.open("./public/contacts.txt", "a")
	file.write "#{@email}\n\n Сообщение:\n #{@message_contacts}\n\n"
	file.close

	@message_title = "Ваше сообщение принято"
	@message_p = "Мы обязательно обработаем Ваше сообщение и ответим Вам"

	Pony.mail({
	  :to => 'dozzator@gmail.com',
	  :from => "#{@email}",
	  :via => :smtp,
	  :via_options => {
	    :address        => 'smtp.gmail.com',
	    :port           => '587',
	    :enable_starttls_auto => true,
	    :user_name      => 'dozzator@gmail.com',
	    :password       => 'MersedesW124',
	    :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
	    :domain         => "HELO" # the HELO domain provided by the client to the server
	  },
	  	subject: "New message from #{@email}",
    	body: "#{@message_contacts}"
	})
	erb :contacts
end

get '/login/form' do
	erb :login
end

post '/login/form' do
	@login = params[:login]
	@login.downcase!
	@login_pass = params[:login_pass]

	if @login == "admin" && @login_pass == "123qwe123"
		erb :secret
	else 
		@message_title = "Error"
		@message_p = "Логин и пароль не верные"

		erb :login
	end
end

def is_hh_empty? hh
		@error = hh.select { |key, _| params[key] == '' }.values.join(", ")

		if @error != ''
			erb :visit
		else
		file_visit = File.open("./public/users.txt", "a")
		file_visit.write "User name - #{@username}, телефон для связи - #{@phone}, запись на дату: #{@date}, выбор цветоа волос - #{@color}, барбер - #{@barber_choise} \n"
		file_visit.close

		@message_title = "Вы записаны на дату #{@date}"
		@message_p = "Для уточнения времени посещения с вами свяжется выбранный барбер по указаному телефону"

		erb :visit
	end
end