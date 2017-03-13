module Fastlane
  module Actions
    module SharedValues
      GIT_CHECKOUT_BRANCH = :GIT_CHECKOUT_BRANCH
    end

    class XctestrunAction < Action
      def self.run(params)
        xcodebuild_action = params[:xcodebuild_action]
        workspace = params[:workspace]
        scheme = params[:scheme]
        destination = params[:destination]

        # construct our command as an array of components
        command = [
            'set -o pipefail &&',
            'xcodebuild',
            "-workspace #{workspace}",
            "-scheme #{scheme}",
            "-destination '#{destination}'",
            "-derivedDataPath 'build'",
            "#{xcodebuild_action} | xcpretty -r junit -r html"
        ].join(' ')

        # execute our command
        Actions.sh('pwd')

        Actions.sh(command)
        UI.message "XcodeBuild Task Finished."
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Run Custom xcodebuild actions'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodebuild_action,
                                       env_name: "XCTESTRUN_XCODEBUILD_ACTION",
                                       description: "The custom action passed to xcodebuild",
                                       is_string: true,
                                       default_value: "build_for_testing"),



         FastlaneCore::ConfigItem.new(key: :workspace,
                                      env_name: "XCTESTRUN_WORKSPACE",
                                      description: "workspace for the project which has all the target",
                                      is_string: true,
                                      default_value: "XCTestRun.xcworkspace"),



        FastlaneCore::ConfigItem.new(key: :scheme,
                                     env_name: "XCTESTRUN_SCHEME",
                                     description: "Scheme to run, test",
                                     is_string: true,
                                     default_value: "XCTestRun"),

        FastlaneCore::ConfigItem.new(key: :destination,
                                    env_name: "XCTESTRUN_DESTINATION",
                                    description: "Simulator or device information",
                                    is_string: true,
                                    default_value: "platform=iOS Simulator,name=iPhone 7,OS=10.2")
        ]
      end

      def self.authors
        ["Shashikant86"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
