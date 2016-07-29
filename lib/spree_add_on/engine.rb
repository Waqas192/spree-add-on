module SpreeAddOn
  class Engine < Rails::Engine
    require "spree/core"
    isolate_namespace Spree
    engine_name "spree_add_on"

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    # rubocop:disable Metrics/LineLength
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    # rubocop:enable Metrics/LineLength

    initializer "spree.register.add_ons" do |app|
      app.config.spree.class_eval do
        attr_accessor :add_ons
      end
      app.config.spree.add_ons = []
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
