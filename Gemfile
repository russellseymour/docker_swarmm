
source "https://rubygems.org"

gem "berkshelf"
gem "chef-sugar"

group :development do
  gem "foodcritic"
  gem "chefspec"

  gem "chefstyle"

  gem "guard"
  gem "guard-foodcritic"
  gem "guard-rubocop"
  gem "guard-rspec"

  gem "test-kitchen"
  gem "kitchen-hyperv"
  gem "kitchen-inspec"

  gem "wdm", ">= 0.1.0" if Gem.win_platform?
  gem "win32console" if Gem.win_platform?
  gem "rb-readline" if Gem.win_platform?
end
