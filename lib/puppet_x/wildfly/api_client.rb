# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'cgi'
require 'json'
require 'net/http/digest_auth'

module PuppetX
  module Wildfly
    class APIClient
      def initialize(address, port, user, password, timeout, secure)
        @username = user
        @password = password
        @uri = if secure
                 URI.parse "https://#{address}:#{port}/management"
               else
                 URI.parse "http://#{address}:#{port}/management"
               end
        @uri.user = CGI.escape(user)
        @uri.password = CGI.escape(password)

        @http_client = Net::HTTP.new @uri.host, @uri.port, nil
        @http_client.read_timeout = timeout
        return unless secure == true

        @http_client.use_ssl = true
        @http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      def authz_header
        digest_auth = Net::HTTP::DigestAuth.new
        authz_request = Net::HTTP::Get.new @uri.request_uri

        retried = 0

        # All http_api providers require Wildfly service to be up, but with systemd there is no guarantee that the service is actually running, therefore we need to retry

        begin
          response = @http_client.request authz_request
        rescue => e
          raise e unless retried + 1 < 6

          retried += 1
          sleep 10
          retry
        end

        sleep 0.05 # We've been returned an auth token.  But if we don't wait a small amount of time before using it, we might stil get a 401. :(

        if response['www-authenticate'] =~ %r{digest}i
          digest_auth.auth_header @uri, response['www-authenticate'], 'POST'
        else
          response['www-authenticate']
        end
      end

      def submit(body, ignore_failed_outcome = false)
        http_request = Net::HTTP::Post.new @uri.request_uri
        http_request.add_field 'Content-type', 'application/json'
        authz = authz_header
        if authz =~ %r{digest}i
          http_request.add_field 'Authorization', authz
        else
          http_request.basic_auth @username, @password
        end

        http_request.body = body.to_json
        http_response = @http_client.request http_request
        response = JSON.parse(http_response.body)

        unless response['outcome'] == 'success' || ignore_failed_outcome
          raise "Failed with: #{response['failure-description']} for #{body.to_json}"
        end

        response
      end
    end
  end
end
