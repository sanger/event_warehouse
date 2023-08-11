# frozen_string_literal: true

RestClient.proxy = ENV.fetch('http_proxy') { ENV.fetch('HTTP_PROXY', nil) }
