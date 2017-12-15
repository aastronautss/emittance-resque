# frozen_string_literal: true

RSpec.describe Emittance::Resque::Dispatcher::JobKlass do
  describe '#generate' do
    let(:callback) { -> { 'foo' } }
    subject { Emittance::Resque::Dispatcher::JobKlass.new(callback) }
    let(:action) { subject.generate }

    it 'returns a class' do
      expect(action).to be_a(Class)
    end

    it 'returns a class that responds to :perform' do
      expect(action).to respond_to(:perform)
    end

    it 'returns a class that inherits from Emittance::Resque::Job' do
      expect(action < Emittance::Resque::Job).to be(true)
    end
  end
end
