require "logger"
require "./client"

module Scry
  module Log
    class_property logger : Logger = Logger.new(nil)

    class ClientLogger < Logger
      def initialize(@client : Client)
        super(@client.io)
      end

      private def write(severity, datetime, progname, message)
        message_type = case severity
                       when INFO
                         LSP::Protocol::MessageType::Info
                       when WARN
                         LSP::Protocol::MessageType::Warning
                       when ERROR, FATAL
                         LSP::Protocol::MessageType::Error
                       else
                         LSP::Protocol::MessageType::Log
                       end
        @client.send("window/logMessage", LSP::Protocol::LogMessageParams.new(message_type, message.to_s))
      end
    end
  end
end
