namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configurando Ambiente: "
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") { %x(rails db:drop)}
      show_spinner("Criando DB...") { %x(rails db:create)}
      show_spinner("Migrando DB...") { %x(rails db:migrate)}
      show_spinner("Populando DB...") { %x(rails db:seed)}
      show_spinner("Cadastrando o Usuário padrão...") {%x(rails dev:add_default_user)}
    else
      puts "Você não está no ambiente de desenvolvimento!"
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
  
end
