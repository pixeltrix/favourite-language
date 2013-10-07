require "thor"
require "octokit"

Octokit.auto_paginate = true

class FavouriteLanguage < Thor
  package_name "Favourite Language"

  desc "by_repo USER", "Get the favourite programming language by the number of repositories"
  def by_repo(user)
    message = "The favourite language of %s by number of repositories is %s"
    language = favorite_language(:by_num_repos, user)
    puts message % [user, language] if language
  end

  desc "by_size USER", "Get the favourite programming labguage by repository size"
  def by_size(user)
    message = "The favourite language of %s by repository size is %s"
    language = favorite_language(:by_size, user)
    puts message % [user, language] if language
  end

  private

  def favorite_language(method, user)
    begin
      send(:"languages_#{method}", user).max_by{ |l, n| n }.first
    rescue Octokit::NotFound
      puts "Sorry, #{user} doesn't exist"
    rescue Octokit::TooManyRequests
      puts "Sorry, your API limit has been reached"
    rescue Octokit::ClientError => e
      puts "Sorry, unexpected client error: #{e.message}"
    rescue Octokit::ServerError => e
      puts "Sorry, unexpected server error: #{e.message}"
    end
  end

  def languages_by_num_repos(user)
    repositories(user).inject({}) do |languages, repository|
      language = repository.language
      languages[language] = languages.fetch(language, 0) + 1
      languages
    end
  end

  def languages_by_size(user)
    repositories(user).inject({}) do |languages, repository|
      language = repository.language
      languages[language] = languages.fetch(language, 0) + repository.size
      languages
    end
  end

  def repositories(user)
    Octokit.repositories(user)
  end
end
