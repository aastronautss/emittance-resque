# frozen_string_literal: true

RSpec.describe Emittance::Resque::Dispatcher::JobKlassName do
  let(:event_klass) { FooEvent }
  let(:object) { Foo }
  let(:method_name) { :bar }
  subject { Emittance::Resque::Dispatcher::JobKlassName.new(event_klass, object, method_name) }

  describe '#generate' do
    let(:action) { subject.generate }

    it 'returns the right format' do
      expect(action).to eq('FooEventFooBarJob')
    end
  end
end
