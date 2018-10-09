require 'sinatra'
require 'pp'
require 'httparty'

if ARGV[0].nil? || ARGV[1].nil?
  puts 'USAGE: ruby app.rb <api-username> <api-token>'
  exit
end

class Client
  def initialize(username, token)
    @username = username
    @token = token
  end

  def reports(program)
    query = {
      filter: {
        program: [program],
        state: ['new', 'triaged'],
      },
      sort: 'reports.last_program_activity_at',
    }

    @reports = HTTParty.get 'https://api.hackerone.com/v1/reports',
      query: query,
      basic_auth: basic_auth
  end

  private

  def basic_auth
    {
      username: @username,
      password: @token,
    }
  end
end

get '/' do
  client = Client.new(ARGV[0], ARGV[1])

  @reports = client.reports('test_organization_h2fmr')

  erb :index
end
