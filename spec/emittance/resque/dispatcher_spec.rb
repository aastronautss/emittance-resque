# frozen_string_literal: true

RSpec.describe Emittance::Resque::Dispatcher do
  before do
    @previous_registrations = Emittance::Resque::Dispatcher.instance_variable_get '@registrations'
    Emittance::Resque::Dispatcher.instance_variable_set '@registrations', {}
  end

  after do
    Emittance::Resque::Dispatcher.instance_variable_set '@registrations', @previous_registrations
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

    it 'returns a set' do
      expect(action).to be_a(Set)
    end

    it 'adds a member to the registration' do
      expect { action }.to(
        change { Emittance::Resque::Dispatcher.registrations_for(FooEvent).length }.by(1)
      )
    end

    context 'with an identifier param' do
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
end
