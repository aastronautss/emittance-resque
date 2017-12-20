# frozen_string_literal: true

require 'emittance/resque/event_serializer/active_record'
require 'ostruct'

RSpec.describe 'Rails integration' do
  before do
    stub_const 'Emittance::Resque::Dispatcher::Jobs', Module.new
    stub_const 'ActiveRecord::Base', OpenStruct
    stub_const 'FooModel', Class.new(ActiveRecord::Base)
    stub_const 'FooWatcher', (Class.new do
      extend Emittance::Watcher

      class << self
        attr_reader :event

        def something_happened(event)
          @event = event
        end
      end
    end)
    stub_const 'FooEmitter', Class.new { extend Emittance::Emitter }

    allow(FooModel).to receive(:find).and_return(FooModel.new(id: 1))

    Emittance.use_broker :resque
    Emittance::Resque.use_serializer Emittance::Resque::EventSerializer::ActiveRecord
  end

  after do
    Emittance::Resque.use_serializer Emittance::Resque::EventSerializer::Default
  end

  context 'when the emitter is an AR model' do
    before do
      stub_const 'FooModel', Class.new(ActiveRecord::Base) { extend Emittance::Emitter }
      allow(FooModel).to receive(:find).and_return(FooModel.new(id: 1))
    end

    it 'serializes and deserializes the emitter' do
      FooWatcher.watch :happening, :something_happened
      FooModel.new(id: 1).emit :happening

      expect(FooWatcher.event.emitter).to be_a(FooModel)
    end
  end

  context 'when an AR model is in the payload as an array' do
    it 'serializes and deserializes the payload' do
      FooWatcher.watch :happening, :something_happened
      FooEmitter.emit :happening, payload: [FooModel.new(id: 1), 1]

      expect(FooWatcher.event.payload).to contain_exactly(kind_of(FooModel), 1)
    end
  end

  context 'when an AR model is in the payload as a hash value' do
    it 'serializes and deserializes the hash value' do
      FooWatcher.watch :happening, :something_happened
      FooEmitter.emit :happening, payload: { model: FooModel.new(id: 1), other: 1 }

      expect(FooWatcher.event.payload['model']).to be_a(FooModel)
      expect(FooWatcher.event.payload['other']).to eq(1)
    end
  end
end
