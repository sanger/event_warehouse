# frozen_string_literal: true

RestClient.proxy = ENV['http_proxy'] || ENV['HTTP_PROXY']
