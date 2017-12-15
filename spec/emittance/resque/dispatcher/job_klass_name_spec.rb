# frozen_string_literal: true

RSpec.describe Emittance::Resque::Dispatcher::JobKlassName do
  let(:event_klass) { FooEvent }
  let(:object) { Foo }
  let(:method_name) { :bar }
  subject { Emittance::Resque::Dispatcher::JobKlassName.new(event_klass, object, method_name) }

  describe '#generate' do
    let(:action) { subject.generate }

    it 'returns the right format' do
      expect(action).to eq('FooEvent::Foo::BarJob')
    end

    context 'with namespaced constants' do
      let(:object) { Foo::Baz }

      it 'squashes the namespace' do
        expect(action).to eq('FooEvent::Foo::Baz::BarJob')
      end
    end
  end
end
