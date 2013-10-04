Gem::Specification.new do |s|
  s.name    = 'favourite-language'
  s.version = '0.1.0'
  s.author  = 'Andrew White'
  s.email   = 'andyw@pixeltrix.co.uk'
  s.summary = <<-EOS
    Provides a command line tool for getting a user's favourite
    programming language from their GitHub public repositories.
  EOS

  s.add_dependency 'thor', '~> 0.18'
  s.add_dependency 'octokit', '~> 2.0'

  s.files = %w[bin/favourite-language favourite-language.gemspec LICENSE.md README.md]
  s.executables = %w[favourite-language]
end
