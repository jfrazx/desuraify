require_relative '../../lib/desuraify'

RSpec.describe Desuraify::Member do
  before do
    @member = Desuraify::Member.new('animdude')
    @member.update
  end

  describe 'member data' do

    it 'should have an activity_points attribute' do
      expect(@member.activity_points.class).to eq(Fixnum)
    end

    it 'should have a country attribute' do
      expect(@member.country.class).to eq(String)
    end

    it 'should have a gender attribute' do
      expect(@member.gender.class).to eq(String)
    end
    
    it 'should have the html page available' do
      expect(@member.html).not_to eq(nil)
      expect(@member.html.class).to eq(String)
    end

    it 'should have an array of images' do
      expect(@member.images.class).to eq(Array)
      expect(@member.images).to eq([])
    end

    it 'should have an image_count' do
      expect(@member.images_count.class).to eq(Fixnum)
    end

    it 'should have a level attribute' do
      expect(@member.level.class).to eq(Float)
    end

    it 'should have an offline attribute' do
      expect(@member.offline.class).to eq(String)
    end

    it 'should have a rank attribute' do
      expect(@member.rank.class).to eq(String)
    end

    it 'should have a site_visits attribute' do
      expect(@member.site_visits.class).to eq(String)
    end

    it 'should have a time_online attribute' do
      expect(@member.time_online.class).to eq(String)
    end

    it 'should have an array of videos' do
      expect(@member.videos.class).to eq(Array)
      expect(@member.videos).to eq([])
    end

    it 'should have a videos_count' do
      expect(@member.videos_count.class).to eq(Fixnum)
    end

    it 'should have a visits attribute' do
      expect(@member.visits.class).to eq(String)
    end

    it 'should have a watchers attribute' do
      expect(@member.watchers.class).to eq(String)
    end
  end
end
