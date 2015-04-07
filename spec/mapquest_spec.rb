require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MapQuest do

  subject { MapQuest }

  describe '.new' do

    context "without api_key" do

      it 'should raise ArgumentError' do
        expect { subject.new }.to raise_error(ArgumentError)
      end

    end

  end

  describe "instance" do

    let(:key) { 'xxx' }
    subject(:instance) { MapQuest.new(key) }

    it { should be_an_instance_of MapQuest }

    its(:api_key)  { should == key }

    describe '#geocoding' do
      subject(:geocoding) { instance.geocoding }
      it { should be_an_instance_of MapQuest::Services::Geocoding }
      its(:mapquest) { should == instance }

    end

    describe '#directions' do
      subject(:directions) { instance.directions }
      it { should be_an_instance_of MapQuest::Services::Directions }
      its(:mapquest) { should == instance }

    end

    describe '#request' do
      api_method = {:location => :geocoding, :version => 1, :call => 'address' }
      subject(:request) { instance.request api_method, { :location => 'London, UK' }, MapQuest::Response }

      fixture = fixture 'geocoding/location_only'
      query = {
          :key => 'xxx',
          :location => 'London, UK'
      }

      stub_request(:get, 'open.mapquestapi.com/geocoding/v1/address').
          with(:query => query).
          to_return(:body => fixture)

      it { should be_an_instance_of MapQuest::Response }
    end

  end

end
