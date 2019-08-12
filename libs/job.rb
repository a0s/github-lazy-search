require 'octokit'
require 'redis'
require 'json'

class Job
  def perform(**args)
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    response = client.search_repositories(args[:query])
    pp response
    items = response.items.map { |item| {
      full_name: item[:full_name],
      html_url: item[:html_url],
      forks: item[:forks],
      watchers: item[:watchers],
      stargazers_count: item[:stargazers_count],
      score: item[:score]
    } }
    message = JSON.dump({
      query_uuid: args[:query_uuid],
      query: args[:query],
      response: items
    })
    App.redis.publish(ENV['WORKERS_OUTPUT_QUEUE'], message)
  end
end
