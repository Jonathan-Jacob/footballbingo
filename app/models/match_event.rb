class MatchEvent < ApplicationRecord
  belongs_to :match

  def self.read_json
    pages = 0
    json = ""
    api_url = "https://soccer.sportmonks.com/api/v2.0/livescores/now?api_token=#{ENV["SPORTMONKS_URL"]}&include=localTeam,visitorTeam,events,lineup,bench"
    open(api_url) do |stream|
      json = JSON.parse(stream.read)
      pages = json['meta']['pagination']['total_pages']
    end
    if pages >= 2
      (2..pages).each do |page|
        open(api_url + "&page=#{page}") do |stream|
          json_page = JSON.parse(stream.read)
          json['data'] += json_page['data']
        end
      end
    end
    json
  end
end
