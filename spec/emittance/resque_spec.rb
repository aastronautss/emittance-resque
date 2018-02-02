# frozen_string_literal: true

RSpec.describe Emittance::Resque do
  it 'has a version number' do
    expect(Emittance::Resque::VERSION).not_to be nil
  end

  describe '.default_queue' do
    let(:action) { Emittance::Resque.default_queue }

    it 'returns the default queue' do
      expect(action).to eq(Emittance::Resque::Dispatcher::DEFAULT_QUEUE)
    end
  end

  describe '.default_queue=' do
    let(:action) { Emittance::Resque.default_queue = :foo }
    before { @old_default_queue = Emittance::Resque.default_queue }
    after { Emittance::Resque::Dispatcher.default_queue = @old_default_queue }

    it 'sets a new default queue' do
      action

      expect(Emittance::Resque.default_queue).to eq(:foo)
    end
  end

  describe '.fanout_queue=' do
    let(:action) { Emittance::Resque.fanout_queue = :foo }

    it 'delegates' do
      expect(Emittance::Resque::Dispatcher).to receive(:fanout_queue=).with(kind_of Symbol)
      action
    end
  end

  describe 'interface contracts' do
    specify { expect(Emittance::Resque::Dispatcher).to respond_to(:fanout_queue=).with(1).argument }
  end
end
