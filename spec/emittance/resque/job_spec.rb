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
    let(:event) { { identifier: :foo, timestamp: Time.now, payload: 'hello world' } }
    let(:action) { job_klass.perform(event) }

    it 'passes to the instance variable' do
      expect_any_instance_of(FooEvent).to receive(:ack!)

      action
    end
  end
end
