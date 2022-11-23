# frozen_string_literal: true
require "active_support/concern"

module ViteRails::Config
  extend ActiveSupport::Concern

  RAILS_CONFIG = %w[
    javascript_tag_options
    stylesheet_tag_options
    image_tag_options
    vite_client_tag_options
  ].freeze

  prepended do
    (RAILS_CONFIG).each do |option|
      define_method(option) { @config[option] }
    end
  end

  class_methods do
    # Override: Default values for a Rails application.
    private def config_defaults
      require 'rails'
      asset_host = Rails.application&.config&.action_controller&.asset_host
      super(
        asset_host: asset_host.is_a?(Proc) ? nil : asset_host,
        mode: Rails.env.to_s,
        root: Rails.root || Dir.pwd,
      )
    end
  end

  private def initialize(attrs)
    RAILS_CONFIG.each do |option|
      attrs[option] = {} if attrs[option].nil?
    end

    super(attrs)
  end
end

ViteRuby::Config.prepend(ViteRails::Config)
