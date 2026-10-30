# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "faker"
require "minitest/autorun"

ENV["GIT_CONFIG_GLOBAL"] = File::NULL
ENV["GIT_CONFIG_NOSYSTEM"] = "1"
Faker::Config.random = Random.new(20_261_029)
