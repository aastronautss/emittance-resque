# frozen_string_literal: true

RSpec.describe Emittance::Resque::Broker do
  describe '.process_event' do
    let(:event) { double 'event' }
    let(:action) { Emittance::Resque::Broker.process_event event }

    it 'sends the event to the dispatcher' do
      expect(Emittance::Resque::Dispatcher).to receive(:process_event).with(event)

      action
    end
  end

  context 'interface contracts' do
    specify { expect(Emittance::Resque::Dispatcher).to respond_to(:process_event).with(1).argument }
  end
end
