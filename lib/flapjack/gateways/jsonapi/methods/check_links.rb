#!/usr/bin/env ruby

require 'sinatra/base'

require 'flapjack/data/check'
require 'flapjack/data/tag'

module Flapjack
  module Gateways
    class JSONAPI < Sinatra::Base
      module Methods
        module CheckLinks

          def self.registered(app)
            app.helpers Flapjack::Gateways::JSONAPI::Helpers::Headers
            app.helpers Flapjack::Gateways::JSONAPI::Helpers::Miscellaneous
            app.helpers Flapjack::Gateways::JSONAPI::Helpers::ResourceLinks

            app.class_eval do
              swagger_args = ['checks', Flapjack::Data::Check,
                              {'tags' => Flapjack::Data::Tag}]

              swagger_post_links(*swagger_args)
              swagger_get_links(*swagger_args)
              swagger_put_links(*swagger_args)
              swagger_delete_links(*swagger_args)
            end

            app.post %r{^/checks/(#{Flapjack::UUID_RE})/links/(tags)$} do
              check_id   = params[:captures][0]
              assoc_type = params[:captures][1]

              resource_post_links(Flapjack::Data::Check, 'checks', check_id, assoc_type)
              status 204
            end

            app.get %r{^/checks/(#{Flapjack::UUID_RE})/(tags)} do
              check_id   = params[:captures][0]
              assoc_type = params[:captures][1]

              status 200
              resource_get_links(Flapjack::Data::Check, 'checks', check_id, assoc_type)
            end

            app.patch %r{^/checks/(#{Flapjack::UUID_RE})/links/(tags)$} do
              check_id   = params[:captures][0]
              assoc_type = params[:captures][1]

              resource_patch_links(Flapjack::Data::Check, 'checks', check_id, assoc_type)
              status 204
            end

            app.delete %r{^/checks/(#{Flapjack::UUID_RE})/links/(tags)/(.+)$} do
              check_id   = params[:captures][0]
              assoc_type = params[:captures][1]
              assoc_ids  = params[:captures][2].split(',').uniq

              resource_delete_links(Flapjack::Data::Check, 'checks', check_id, assoc_type,
                                    assoc_ids)
              status 204
            end
          end
        end
      end
    end
  end
end