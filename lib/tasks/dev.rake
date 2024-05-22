namespace :dev do
  desc "Configurando Ambiente: "
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") { %x(rails db:drop)}
      show_spinner("Criando DB...") { %x(rails db:create)}
      show_spinner("Migrando DB...") { %x(rails db:migrate)}
      show_spinner("Populando DB...") { %x(rails db:seed)}
    else
      puts "Você não está no ambiente de desenvolvimento!"
    end
  end

  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
  
end
