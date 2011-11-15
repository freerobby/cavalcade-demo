# environment.rb - responsible for loading all resources needed to run jobs
require "cavalcade"

Dir[File.dirname(__FILE__) + "/jobs/*.rb"].each {|file| require file }
