# frozen_string_literal: true

RSpec.describe Emittance::Resque::Job do
  let(:job_klass) do
    Class.new(Emittance::Resque::Job) do
      def perform(event)
        event.ack!
      end
    end
  end

  describe '.perform' do
    let(:event) { double 'Event' }
    let(:action) { job_klass.perform(event) }

    it 'passes to the instance variable' do
      expect(event).to receive(:ack!)

      action
    end
  end
end
