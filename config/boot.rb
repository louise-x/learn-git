ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# test bootsnap
require 'bootsnap/setup'

# if %w[s server c consol].any? {|a| ARGV.include?(a)}
#   puts "=> Booting Rails"
# end
# app_dir = "/var/www/my-test"
# shared_dir = "#{app_dir}/shared"
# Bootsnap.setup(
#     cache_dir: "#{shared_dir}/tmp/cache"
# )