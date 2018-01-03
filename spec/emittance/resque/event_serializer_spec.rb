# frozen_string_literal: true

RSpec.describe Emittance::Resque::EventSerializer do
  let(:serializer) { double 'serializer' }
  let(:event) { double 'event' }
  let(:event_hash) { double 'event_hash' }
  subject { Emittance::Resque::EventSerializer }

  before { @previous_serializer = subject.send(:serializer) }
  after { subject.use_serializer @previous_serializer }

  describe '.use_serializer' do
    let(:action) { subject.use_serializer serializer }

    it 'sets the serializer' do
      action

      expect(subject.send(:serializer)).to eq(serializer)
    end
  end

  describe '.serialize' do
    before { subject.use_serializer serializer }

    it 'delegates to serializer' do
      expect(serializer).to receive(:serialize).with(event)

      subject.serialize event
    end
  end

  describe '.deserialize' do
    before { subject.use_serializer serializer }

    it 'delegates to serializer' do
      expect(serializer).to receive(:deserialize).with(event_hash)

      subject.deserialize event_hash
    end
  end
end
