require 'rack-rewrite'
require './repository'

db = Sequel.connect ENV['DATABASE_URL'] || 'sqlite://development.db'

public_directory = File.join Dir.pwd, 'public'

run Rack::Builder.new {
  use Rack::Config do |env|
    env['repository.path'] = File.join public_directory, 'javascript', 'game'
  end

  run Repository

  use Rack::Rewrite do
    index = '/public/html/index.html'

    rewrite '/', index
    rewrite %r{^/\?[0-9]+$}, index
  end

  map '/public' do
    run Rack::Directory.new public_directory
  end
}
