require_relative '../../lib/desuraify'

RSpec.describe Desuraify::Game do
  before do 
    @game = Desuraify::Game.new("dominions-4-thrones-of-ascensions")
  end

  describe "initialization" do
    it 'has an ancestor chain that includes Desuraify::Base' do
      expect(@game.class.ancestors.include?(Desuraify::Base)).to eq(true)
    end

    it 'should be an instance of Desuraify::Game' do
      expect(@game.instance_of?(Desuraify::Game)).to eq(true)
    end

    it 'should have a Typhoeus::Hydra instance available' do
      expect(@game.hydra.class).to eq(Typhoeus::Hydra)
    end

    it 'should have an id' do
      expect(@game.id).to eq("dominions-4-thrones-of-ascensions")
    end

    it 'should have an attributes array of methods that are nil' do
      @game.attributes.each do |attribute|
        expect(@game.send(attribute)).to eq(nil)
      end
    end
  end

  describe "game data" do
    before do
      @game.update
    end

    it "should have a title" do
      expect(@game.title.class).to eq(String)
    end

    it 'should have a page_title' do
      expect(@game.page_title.class).to eq(String)
    end

    it 'should have an official_page' do
      expect(@game.official_page.class).to eq(String)
    end

    # this may change if the developer adds game videos
    it 'should have an array of videos' do
      expect(@game.videos.class).to eq(Array)
      expect(@game.videos).to eq([])
    end

    it 'should have an array of images' do
      expect(@game.images.class).to eq(Array)
      expect(@game.images).not_to eq([])
    end

    describe "developers" do
      it 'should have an array of developer hashes' do
        expect(@game.developers.class).to eq(Array)
        expect(@game.developers).not_to eq([])
        expect(@game.developers.first.class).to eq(Hash)
      end

      it 'should have attributes in the developer hash' do
        expect(@game.developers.first[:name].class).to eq(String)
        expect([TrueClass, FalseClass].include?(@game.developers.first[:company].class)).to eq(true)
        expect(@game.developers.first[:id].class).to eq(String)
      end
    end

    describe "publishers" do
      it 'should have an array of publisher hashes' do
        expect(@game.publishers.class).to eq(Array)
        expect(@game.publishers).not_to eq([])
        expect(@game.publishers.first.class).to eq(Hash)
      end

      it 'should have attributes in the publisher hash' do
        expect(@game.publishers.first[:name].class).to eq(String)
        expect([TrueClass, FalseClass].include?(@game.publishers.first[:company].class)).to eq(true)
        expect(@game.publishers.first[:id].class).to eq(String)
      end
    end

    describe 'engines' do
      it 'should have an array of engine hashes' do
        expect(@game.publishers.class).to eq(Array)
        expect(@game.publishers).not_to eq([])
        expect(@game.publishers.first.class).to eq(Hash)
      end

      it 'should have attributes in the engine hash' do
        expect(@game.engines.first[:name].class).to eq(String)
        expect(@game.engines.first[:id].class).to eq(String)
      end
    end

    describe 'platforms' do
      it 'should have an array of platforms' do
        expect(@game.platforms.class).to eq(Array)
        expect(@game.platforms).not_to eq([])
      end

      # it is my understanding that desura does not support platforms other that those listed
      it 'should be included in ["Windows", "Mac", "Linux"]' do
        platforms = ["Windows", "Mac", "Linux"]

        @game.platforms.each do |platform|
          expect(platforms.include?(platform)).to eq(true)
        end
      end
    end

    it 'should have an array of player modes' do
      expect(@game.players.class).to eq(Array)
      expect(@game.players).not_to eq([])
    end

    it 'should have an array of game classifications (projects)' do
      expect(@game.projects.class).to eq(Array)
      expect(@game.projects).not_to eq([])
    end

    it 'should have an array of themes' do
      expect(@game.themes.class).to eq(Array)
      expect(@game.themes).not_to eq([])
    end

    it 'should have a rank' do
      expect(@game.rank.class).to eq(String)
    end

    it 'should have a rating' do
      expect(@game.rating.class).to eq(Float)
    end

    describe 'summary' do
      it 'should be an array' do
        expect(@game.summary.class).to eq(Array)
        expect(@game.summary).not_to eq([])
      end

      it 'should be an array of strings' do
        @game.summary.each do |sentence|
          expect(sentence.class).to eq(String)
        end
      end
    end

    it 'should have a boxshot image extension of jpg' do
      ext = @game.boxshot.split("/").last.split(".").last
      expect(ext).to eq("jpg")
    end

    it 'should have an updated attribute' do
      expect(@game.updated.class).to eq(String)
    end

    it 'should have an images_count' do
      expect(@game.images_count.class).to eq(Fixnum)
    end

    it 'should have a videos_count' do
      expect(@game.videos_count.class).to eq(Fixnum)
    end

    it 'should have a news_count' do
      expect(@game.news_count.class).to eq(Fixnum)
    end

    it 'should have an array of genres' do
      expect(@game.genres.class).to eq(Array)
      expect(@game.genres).not_to eq([])
    end

    it 'should have the html page available' do
      expect(@game.html).not_to eq(nil)
      expect(@game.html.class).to eq(String)
    end

    it 'should have a visits attribute' do
      expect(@game.visits.class).to eq(String)
    end

    it 'should have a watchers attribute' do
      expect(@game.watchers.class).to eq(String)
    end

    #langauges not yet implemented by desura, we'll be ready when they do
    it 'should have languages equal to nil' do
      expect(@game.languages).to eq(nil)
    end

    describe /\$\d+.\d+/ do
      it { should match(@game.price) }
      it { should match(@game.original_price) }
    end
  end
end
