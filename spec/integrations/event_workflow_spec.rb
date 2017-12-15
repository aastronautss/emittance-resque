# frozen_string_literal: true

RSpec.describe 'The event workflow' do
  before do
    Emittance.use_broker :resque
    allow(Emittance::SpecFixtures::FooWatcher).to receive(:bar).with(anything)
  end
  after { Emittance::Resque::Dispatcher.clear_registrations! }

  it 'runs for a single listener' do
    Emittance::SpecFixtures::FooWatcher.watch :foo, :bar
  end
end
