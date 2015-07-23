require_relative '../../lib/desuraify'

RSpec.describe Desuraify::Company do
  before do
    @company = Desuraify::Company.new('illwinter-game-design')
    @company.update
  end

  describe 'company data' do
    it 'should have an address array' do
      expect(@company.address.class).to eq(Array)
      expect(@company.address).not_to eq([])
    end

    it 'should have a company' do
      expect(@company.company.class).to eq(String)
    end

    it 'should have an engines_count' do
      expect(@company.engines_count.class).to eq(Fixnum)
    end

    it 'should have a games_count' do
      expect(@company.games_count.class).to eq(Fixnum)
    end

    it 'should have the html page available' do
      expect(@company.html.class).to eq(String)
    end

    it 'should have an array of images' do
      expect(@company.images.class).to eq(Array)
      expect(@company.images).to eq([])
    end

    it 'should have an images_count' do
      expect(@company.images_count.class).to eq(Fixnum)
    end

    it 'should have a members_count' do
      expect(@company.members_count.class).to eq(Fixnum)
    end

    # not yet implemented
    # it 'should have a members array' do
    #   expect(@company.members.class).to eq(Array)
    #   expect(@company.members).not_to eq([])
    # end

    it 'should have a news_count' do
      expect(@company.news_count.class).to eq(Fixnum)
    end

    it 'should have an office' do
      expect(@company.office.class).to eq(String)
    end

    it 'should have an official_page' do
      expect(@company.official_page.class).to eq(String)
    end

    it 'should have a phone' do
      expect(@company.phone.class).to eq(String)
    end

    it 'should have a rank' do
      expect(@company.rank.class).to eq(String)
    end

    it 'should have an array of videos' do
      expect(@company.videos.class).to eq(Array)
      # expect(@company.videos).not_to eq([])
    end

    it 'should have a videos_count' do
      expect(@company.videos_count.class).to eq(Fixnum)
    end

    it 'should have a visits attribute' do
      expect(@company.visits.class).to eq(String)
    end

    it 'should have a watchers attribute' do
      expect(@company.watchers.class).to eq(String)
    end
  end
end