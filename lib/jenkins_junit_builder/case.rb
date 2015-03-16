require 'pathname'
require Pathname.new(__dir__) + 'system_message'

module JenkinsJunitBuilder
  class Case
    attr_accessor :name, :time, :classname
    attr_reader :result, :message

    RESULT_PASSED  = :passed
    RESULT_SKIPPED = :skipped
    RESULT_FAILURE = :failure
    RESULT_ERROR   = :error

    # Should we report any message for this result type?
    def result_has_message?
      [RESULT_FAILURE, RESULT_ERROR, RESULT_SKIPPED].include? result
    end

    def system_out
      @system_out ||= SystemMessage.new
    end

    def system_err
      @system_err ||= SystemMessage.new
    end

    # @param [Symbol] type [:passed, :skipped, :failure, :error]
    def result=(type)
      throw ArgumentError.new "'#{type.to_s}' is not a valid case result type" unless [:passed, :skipped, :failure, :error].include? type

      @result = type
    end

    def passed
      self.result = RESULT_PASSED
    end

    def skipped
      self.result = RESULT_SKIPPED
    end

    def failure
      self.result = RESULT_FAILURE
    end

    def error
      self.result = RESULT_ERROR
    end

    # Short message provided by the result type element.
    # Not used in non-failing tests.
    #
    # @param [String] msg
    def message=(msg)
      @message = msg
    end

  end
end