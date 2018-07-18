#!/usr/bin/env ruby
require 'pp'
require 'httparty'

REPORTING_BASE_URI = ENV.fetch('REPORTING_BASE_URI')
REPORTING_API_TOKEN = ENV.fetch('REPORTING_API_TOKEN')

def prepare_params(message)
  {
    token: REPORTING_API_TOKEN,
    reporter: 'Stefan & Johannes Fula Ord-skickare',
    text: message
  }

end

def submit(message)
  response = HTTParty.post(
    "#{REPORTING_BASE_URI}/api/v1/reports",
     body: prepare_params(message).to_json,
     headers: headers
  )
  pp response.body unless response.code == 201
end

def headers
  {}.tap do |h|
    h['Content-Type'] = 'application/json'
    h['Accept'] = 'application/json'
  end
end


File.open(File.join(Dir.pwd, 'hate-words.csv'), "r") do |f|
  f.each_line do |line|
    phrase = line.gsub("\n",'')
    success = submit(phrase)
  end
end
