# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/config_constants'

RSpec.describe ConfigConstants do
  describe('self#merge_recursively') do
    let(:old) { { hash: { subhash: 'subhash' } } }

    it 'adds a new key' do
      merged = described_class.merge_recursively(old, new: 'new')
      expect(merged[:new]).to eq('new')
    end

    it 'replaces value in subhash' do
      merged = described_class.merge_recursively(old, hash: { subhash: 'foo' })
      expect(merged[:hash][:subhash]).to eq('foo')
    end

    it 'adds and replaces value in subhash' do
      old = { the: { answer: { is: 'qux' }, is: 'qux' } }
      novel = { the: { answer: { is: '42' }, computer: 'said' } }
      merged = described_class.merge_recursively(old, novel)
      expect(merged[:the][:answer][:is]).to eq('42')
      expect(merged[:the][:computer]).to eq('said')
    end
  end
end
