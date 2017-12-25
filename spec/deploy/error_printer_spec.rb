# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/error_printer'

RSpec.describe Deploy::ErrorPrinter do
  let(:output) { StringIO.new }
  let(:printer) { described_class.new(%w[foo bar], output) }

  it 'prints a header' do
    printer.dump
    expect(output.string).to include(described_class::PRINTER_HEADER)
  end

  it 'prints each error in one line' do
    printer.dump
    expect(output.string).to include("foo\n")
  end

  it 'prints a footer' do
    printer.dump
    expect(output.string).to include(described_class::PRINTER_FOOTER)
  end

  it 'does nothing if no errors' do
    printer = described_class.new([], output)
    expect(printer.dump).to be_nil
  end
end
