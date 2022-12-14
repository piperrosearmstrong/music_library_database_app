require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_tables
  artists_sql = File.read('spec/seeds/artists_seeds.sql')
  albums_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_app_test' })
  connection.exec(artists_sql)
  connection.exec(albums_sql)
end

describe Application do
  include Rack::Test::Methods

  before(:each) do 
    reset_tables
  end

  let(:app) { Application.new }

  # context 'testing GET ./albums' do
  #   it 'should return the list of albums' do
  #     response = get('/albums')

  #     expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq(expected_response)
  #   end
  # end

  context 'testing GET ./albums' do
    it 'should return the list of albums' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('Doolittle')
      expect(response.body).to include('1989')
      expect(response.body).to include('Surfer Rosa')
      expect(response.body).to include('1988')
    end

    it 'returns a link to each album' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Link</a>')
      expect(response.body).to include('<a href="/albums/6">Link</a>')
      expect(response.body).to include('<a href="/albums/9">Link</a>')
    end
  end

  context 'GET /albums/:id' do
    it 'returns info about album 1' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989') 
      expect(response.body).to include('Artist: Pixies') 
    end
  end

  context 'GET /albums/:id' do
    it 'returns info about album 2' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988') 
      expect(response.body).to include('Artist: Pixies') 
    end
  end

  context 'GET /albums/new' do
    it 'returns the form page' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title">')
      expect(response.body).to include('<input type="text" name="release_year">')
      expect(response.body).to include('<input type="text" name="artist_id">')
    end
  end

  context 'testing POST /albums' do
    it 'returns a success page' do
      response = post(
        '/albums',
          title: 'Voyage', 
          release_year: '2022', 
          artist_id: '2'
      )

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Your album has been added!</h1>')
    end

    it 'should validate album parameters' do
      response = post(
        '/albums',
        invalid_artist_title: "OK Computer",
        invalid_info: 123
      )

      expect(response.status).to eq(400)
    end
  end

  context 'testing GET ./artists' do
    it 'returns the list of artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies')
      expect(response.body).to include('Rock')
      expect(response.body).to include('ABBA')
      expect(response.body).to include('Pop')
    end

    it 'returns a link to each artist' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/2">Link</a>')
      expect(response.body).to include('<a href="/artists/3">Link</a>')
    end
  end

  context 'testing GET /artists/:id' do
    it 'returns info about artist 1' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context 'testing GET /artists/:id' do
    it 'returns info about artist 2' do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end

  context 'GET /artists/new' do
    it 'returns the form page' do
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name">')
      expect(response.body).to include('<input type="text" name="genre">')
    end
  end

  context 'testing POST /artists' do
    it 'returns a success page' do
      response = post(
        '/artists',
          name: 'FKA Twigs', 
          genre: 'Avant-Pop', 
      )

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Your artist has been added!</h1>')
    end

    it 'should validate artist parameters' do
      response = post(
        '/artists',
        invalid_artist_name: "Nina Simone",
        invalid_info: 123
      )

      expect(response.status).to eq(400)
    end
  end
end

# Revised Old Code

# context 'POST ./albums' do
  #   it 'should create a new album' do
  #     response = post(
  #       '/albums', 
  #       title: 'Voyage', 
  #       release_year: '2022', 
  #       artist_id: '2'
  #     )

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')

  #     response = get('/albums')

  #     expect(response.body).to include('Voyage')
  #   end
  # end



    # context 'testing GET ./artists' do
  #   it 'should return the list of artists' do
  #     response = get('/artists')

  #     expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq(expected_response)
  #   end
  # end

  #   context 'POST ./artists' do
#     it 'should create a new artist' do
#       response = post(
#         '/artists', 
#         name: 'Wild Nothing', 
#         genre: 'Indie'
#       )

#       expect(response.status).to eq(200)
#       expect(response.body).to eq('')

#       response = get('/artists')

#       expect(response.body).to include('Wild Nothing')
#     end
#   end
# end
