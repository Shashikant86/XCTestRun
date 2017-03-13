require 'fastlane'
require 'scan'

module Xcode8
  class << self
    attr_accessor :runner

    def xcodebuild(args)
      raise 'nil runner' unless runner
      runner.execute_action(:xcodebuild, ::Fastlane::Actions::XcodebuildAction, [args], custom_dir: nil)
    end

    # args :scheme - required
    def _xcodebuild(command_name, args)
      raise 'missing opts' unless args
      raise 'opts must be a hash' unless args.is_a?(Hash)

      workspace = args.fetch(:workspace, 'XCTestRun.xcworkspace')
      scheme = args.fetch(:scheme)
      destination = args.fetch(:destination, 'platform=iOS Simulator,name=iPhone 7,OS=10.2')
      derived_data = args.fetch(:derived_data, 'xctestrun')

      xcodebuild(
          workspace: workspace,
          scheme: scheme,
          destination: destination,
          derivedDataPath: derived_data,
          xcargs: command_name
      )
    end

    def build_for_testing(args)
      _xcodebuild('build-for-testing', args)
    end

    def test_without_building(args)
      _xcodebuild('test-without-building', args)
    end
  end
end
