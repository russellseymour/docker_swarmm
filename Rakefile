require "rspec/core/rake_task"
require "chefstyle"
require "rubocop/rake_task"
require "foodcritic"
require "kitchen"
require "chefspec"

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc "Run Ruby style checks"
  RuboCop::RakeTask.new do |task|
    task.options << "--display-cop-names"
  end

  desc "Run Chef style checks"
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ["any"],
      tags: [
        "~FC005",
        "~FC023",
        "~FC078",
      ],
    }
  end
end

desc "Run all style checks"
task style: ["style:chef", "style:ruby"]

# Rspec and ChefSpec
desc "Run ChefSpec examples"
RSpec::Core::RakeTask.new(:spec)
