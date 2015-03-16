module JenkinsJunitBuilder
  class SystemMessage

    def initialize(msg = nil)
      @message     = []
      self.message = msg unless msg.nil?
    end

    def size
      @message.size
    end

    def to_s
      @message.join "\n"
    end

    def message=(msg)
      @message = [msg]
    end

    def <<(msg)
      @message << msg
    end

  end
end