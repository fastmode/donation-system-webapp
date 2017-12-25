# frozen_string_literal: true

module Deploy
  class ErrorPrinter
    PRINTER_HEADER = %(
--------------------------------------------------------------------------
  ERRORS
--------------------------------------------------------------------------
)

    PRINTER_FOOTER = %(
--------------------------------------------------------------------------
)

    def initialize(errors, output = $stdout)
      @errors = errors
      @output = output
    end

    def dump
      return if errors.empty?
      output.print PRINTER_HEADER
      output.print errors.join("\n")
      output.print PRINTER_FOOTER
    end

    private

    attr_reader :errors, :output
  end
end
