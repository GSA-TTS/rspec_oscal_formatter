# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe RSpecOscalFormatter::Configuration do
  it 'allows setting the use_timestamp_dirs flag' do
    expect { subject.use_timestamp_dirs! }.to change(subject, :use_timestamp_dirs?).from(false).to true
  end

  describe '#output_directory' do
    it 'raises an ArgumentError when unset' do
      expect { subject.output_directory }.to raise_error(ArgumentError)
    end

    it 'returns the set option' do
      subject.output_directory = '/tmp'
      expect(subject.output_directory).to eq Pathname.new('/tmp')
    end
  end
end
