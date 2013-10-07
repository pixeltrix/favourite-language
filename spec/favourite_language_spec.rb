require 'favourite_language'
require 'json'
require 'ostruct'

describe FavouriteLanguage do
  def capture
    stdout, $stdout = $stdout, StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = stdout
  end

  def fixture_path
    File.expand_path('../fixtures/repositories.json', __FILE__)
  end

  def repositories
    @repositories ||= JSON.parse(File.read(fixture_path)).map{ |repo| OpenStruct.new(repo) }
  end

  shared_examples "error handling" do
    it "should display an error message if the user doesn't exist" do
      subject.stub(:repositories) { raise Octokit::NotFound }
      expect(output).to eq("Sorry, pixeltrix doesn't exist\n")
    end

    it "should display an error message if the API limit has been reached" do
      subject.stub(:repositories) { raise Octokit::TooManyRequests }
      expect(output).to eq("Sorry, your API limit has been reached\n")
    end

    it "should display an error message if the server returns a 4XX error" do
      response = {
        :method => 'get',
        :url    => 'https://api.github.com/users/pixeltrix/repos',
        :status => 403,
        :body   => {
          :message => 'Forbidden'
        }
      }

      subject.stub(:repositories) { raise Octokit::ClientError.new(response) }
      expect(output).to eq("Sorry, unexpected client error: GET https://api.github.com/users/pixeltrix/repos: 403 - Forbidden\n")
    end

    it "should display an error message if the server returns a 5XX error" do
      response = {
        :method => 'get',
        :url    => 'https://api.github.com/users/pixeltrix/repos',
        :status => 503,
        :body   => {
          :message => 'Service Unavailable'
        }
      }

      subject.stub(:repositories) { raise Octokit::ClientError.new(response) }
      expect(output).to eq("Sorry, unexpected client error: GET https://api.github.com/users/pixeltrix/repos: 503 - Service Unavailable\n")
    end

    it "shouldn't capture other errors" do
      subject.stub(:repositories) { raise RuntimeError }
      expect{ output }.to raise_error(RuntimeError)
    end
  end

  context "when determining favourite language by repository size" do
    let(:output) do
      capture { subject.by_size('pixeltrix') }
    end

    include_examples "error handling"

    it "should display PHP as the most popular language" do
      subject.stub(:repositories) { repositories }
      expect(output).to eq("The favourite language of pixeltrix by repository size is PHP\n")
    end
  end

  context "when determining favourite language by number of repositories" do
    let(:output) do
      capture { subject.by_repo('pixeltrix') }
    end

    include_examples "error handling"

    it "should display Ruby as the most popular language" do
      subject.stub(:repositories) { repositories }
      expect(output).to eq("The favourite language of pixeltrix by number of repositories is Ruby\n")
    end
  end
end
