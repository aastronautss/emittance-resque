# frozen_string_literal: true

RSpec.describe Emittance::Resque::Dispatcher do
  after { Emittance::Resque::Dispatcher.clear_registrations! }

  describe '.process_event' do
    let(:event) { FooEvent.new Foo, Time.now, 'hello world' }
    let(:action) { Emittance::Resque::Dispatcher.process_event event }

    context 'when there is one registration' do
      before do
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :baz
      end

      it 'queues a job' do
        expect(::Resque).to receive(:enqueue).once

        action
      end
    end

    context 'when there are multiple registrations' do
      before do
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :foo
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :bar
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :baz
      end

      it 'queues multiple jobs' do
        expect(::Resque).to receive(:enqueue).exactly(3).times

        action
      end
    end

    context 'when there are registrations for other events' do
      before do
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :foo
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :bar
        Emittance::Resque::Dispatcher.register_method_call FooEvent, Bar, :baz

        Emittance::Resque::Dispatcher.register_method_call BarEvent, Foo, :foo
      end

      it 'queues multiple times for the given event' do
        expect(::Resque).to receive(:enqueue).exactly(3).times.with(kind_of(Class), hash_including(identifier: :foo))

        action
      end

      it 'does not queue for the event that isn\'t given' do
        expect(::Resque).to receive(:enqueue).exactly(0).times.with(kind_of(Class), hash_including(identifier: :bar))

        action
      end
    end
  end

  describe '.register' do
    let(:action) { Emittance::Resque::Dispatcher.register('foo') { 'bar' } }

    it 'raises an error' do
      expect { action }.to raise_error(Emittance::Resque::InvalidCallbackError)
    end
  end

  describe '.register_method_call' do
    let(:event) { FooEvent }
    let(:object) { Foo }
    let(:method_name) { :bar }
    let(:action) { Emittance::Resque::Dispatcher.register_method_call(event, object, method_name) }

    it 'returns a collection' do
      expect(action).to respond_to(:each)
    end

    it 'adds a member to the registration' do
      expect { action }.to(
        change { Emittance::Resque::Dispatcher.registrations_for(FooEvent).length }.by(1)
      )
    end

    context 'when given an identifier' do
      let(:event) { :foo }

      it 'retrieves the proper event and registers the callback' do
        expect { action }.to(
          change { Emittance::Resque::Dispatcher.registrations_for(FooEvent).length }.by(1)
        )
      end
    end

    context 'when the object is not a module or class' do
      let(:object) { Foo.new }

      it 'raises an error' do
        expect { action }.to raise_error(Emittance::Resque::InvalidCallbackError)
      end
    end
  end

  describe '.registrations_for' do
    let(:event) { FooEvent }
    let(:action) { Emittance::Resque::Dispatcher.registrations_for event }

    it 'returns a set' do
      expect(action).to respond_to(:each)
    end

    context 'when registration is not empty' do
      before { Emittance::Resque::Dispatcher.register_method_call FooEvent, Foo, :bar }

      it 'returns a non-empty set' do
        expect(action).to_not be_empty
      end

      it 'returns a set full of classes' do
        expect(action.first).to be_a(Class)
      end
    end

    context 'when given an identifier' do
      let(:event) { :foo }

      before { Emittance::Resque::Dispatcher.register_method_call FooEvent, Foo, :bar }

      it 'returns the same thing as it would given an event class' do
        expect(action.first).to be_a(Class)
      end
    end
  end

  describe '.clear_registrations_for!' do
    let(:event) { FooEvent }
    let(:action) { Emittance::Resque::Dispatcher.clear_registrations_for! event }

    before { Emittance::Resque::Dispatcher.register_method_call FooEvent, Foo, :bar }

    it 'empties the registration set' do
      action

      expect(Emittance::Resque::Dispatcher.registrations_for event).to be_empty
    end

    it 'leaves other registrations untouched' do
      Emittance::Resque::Dispatcher.register_method_call BarEvent, Foo, :bar
      action

      expect(Emittance::Resque::Dispatcher.registrations_for BarEvent).to_not be_empty
    end
  end

  describe '.clear_registrations!' do
    let(:action) { Emittance::Resque::Dispatcher.clear_registrations! }

    before do
      Emittance::Resque::Dispatcher.register_method_call FooEvent, Foo, :bar
      Emittance::Resque::Dispatcher.register_method_call BarEvent, Foo, :bar
      Emittance::Resque::Dispatcher.register_method_call BarEvent, Bar, :baz
    end

    it 'removes registrations with single subscribers' do
      action

      expect(Emittance::Resque::Dispatcher.registrations_for FooEvent).to be_empty
    end

    it 'removes registrations with multiple subscribers' do
      action

      expect(Emittance::Resque::Dispatcher.registrations_for BarEvent).to be_empty
    end
  end
end
