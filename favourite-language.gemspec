Gem::Specification.new do |s|
  s.name     = 'favourite-language'
  s.version  = '0.1.1'
  s.author   = 'Andrew White'
  s.email    = 'andyw@pixeltrix.co.uk'
  s.homepage = 'https://github.com/pixeltrix/favourite-language'
  s.summary  = <<-EOS
    Provides a command line tool for getting a user's favourite
    programming language from their GitHub public repositories.
  EOS

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'thor', '~> 0.18'
  s.add_dependency 'octokit', '~> 2.0'
  s.add_development_dependency 'rspec', '~> 2.14'

  s.files = [
    'bin/favourite-language',
    'lib/favourite_language.rb',
    'favourite-language.gemspec',
    'LICENSE.md',
    'README.md'
  ]

  s.executables = %w[favourite-language]
end
