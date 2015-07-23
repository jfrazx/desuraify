require_relative '../../lib/desuraify'

RSpec.describe Desuraify::Engine do
  before do
    @engine = Desuraify::Engine.new('unity')
    @engine.update
  end

  describe 'engine data' do
    describe "developers" do
      it 'should have an array of developer hashes' do
        expect(@engine.developers.class).to eq(Array)
        expect(@engine.developers).not_to eq([])
        expect(@engine.developers.first.class).to eq(Hash)
      end

      it 'should have attributes in the developer hash' do
        expect(@engine.developers.first[:name].class).to eq(String)
        expect([TrueClass, FalseClass].include?(@engine.developers.first[:company].class)).to eq(true)
        expect(@engine.developers.first[:id].class).to eq(String)
      end
    end

    # not yet implemented
    # it 'should have an array of games' do
    #   expect(@engine.games.class).to eq(Array)
    #   expect(@engine.games).not_to eq([])
    # end

    it 'should have a games_count attribute' do
      expect(@engine.games_count.class).to eq(Fixnum)
    end

    it 'should have the html page available' do
      expect(@engine.html).not_to eq(nil)
      expect(@engine.html.class).to eq(String)
    end

    it 'should have an array of images' do
      expect(@engine.images.class).to eq(Array)
      expect(@engine.images).to eq([])
    end

    it 'should have an image_count' do
      expect(@engine.images_count.class).to eq(Fixnum)
    end

    it 'has a license attribute' do
      expect(@engine.license.class).to eq(String)
    end

    # not yet implemented
    # it 'has an array of news' do
    #   expect(@engine.news.class).to eq(Array)
    #   expect(@engine.news).not_to eq([])
    # end

    it 'should have a news_count' do
      expect(@engine.news_count.class).to eq(Fixnum)
    end

    it 'should have an official_page' do
      expect(@engine.official_page.class).to eq(String)
    end

    it 'should have a page_title' do
      expect(@engine.page_title.class).to eq(String)
    end

    it 'should have an array of platforms' do
      expect(@engine.platforms.class).to eq(Array)
      expect(@engine.platforms).not_to eq([])
    end

    describe "publishers" do
      it 'should have an array of publisher hashes' do
        expect(@engine.publishers.class).to eq(Array)
        expect(@engine.publishers).not_to eq([])
        expect(@engine.publishers.first.class).to eq(Hash)
      end

      it 'should have attributes in the publisher hash' do
        expect(@engine.publishers.first[:name].class).to eq(String)
        expect([TrueClass, FalseClass].include?(@engine.publishers.first[:company].class)).to eq(true)
        expect(@engine.publishers.first[:id].class).to eq(String)
      end
    end

    it 'should have a rank attribute' do
      expect(@engine.rank.class).to eq(String)
    end

    it 'should have a rating attribute' do
      expect(@engine.rating.class).to eq(Float)
    end

    it 'should have a release_date attribute' do
      expect(@engine.release_date.class).to eq(String)
    end

    describe 'summary' do
      it 'should be an array' do
        expect(@engine.summary.class).to eq(Array)
        expect(@engine.summary).not_to eq([])
      end

      it 'should be an array of strings' do
        @engine.summary.each do |sentence|
          expect(sentence.class).to eq(String)
        end
      end
    end

    it "should have a title attribute" do
      expect(@engine.title.class).to eq(String)
    end

    it 'should have an updated attribute' do
      expect(@engine.updated.class).to eq(String)
    end

    it 'should have an array of videos' do
      expect(@engine.videos.class).to eq(Array)
      # expect(@engine.videos).not_to eq([])
    end

    it 'should have a videos_count' do
      expect(@engine.videos_count.class).to eq(Fixnum)
    end

    it 'should have a visits attribute' do
      expect(@engine.visits.class).to eq(String)
    end

    it 'should have a watchers attribute' do
      expect(@engine.watchers.class).to eq(String)
    end
  end
end
