# frozen_string_literal: true

RSpec.describe 'The event workflow' do
  before do
    stub_const 'Emittance::Resque::Dispatcher::Jobs', Module.new
    Emittance.use_broker :resque
  end
  after { Emittance::Resque::Dispatcher.clear_registrations! }

  it 'runs for a single listener' do
    Emittance::SpecFixtures::FooWatcher.watch :foo, :bar

    expect(Emittance::SpecFixtures::FooWatcher).to receive(:bar)

    Emittance::SpecFixtures::FooEmitter.new.emit_foo
  end

  it 'runs for multiple listeners to the single event' do
    Emittance::SpecFixtures::FooWatcher.watch :foo, :bar
    Emittance::SpecFixtures::BarWatcher.watch :foo, :bar

    expect(Emittance::SpecFixtures::FooWatcher).to receive(:bar)
    expect(Emittance::SpecFixtures::BarWatcher).to receive(:bar)

    Emittance::SpecFixtures::FooEmitter.new.emit_foo
  end

  it 'runs for single listeners to multiple events' do
    Emittance::SpecFixtures::FooWatcher.watch :foo, :hello
    Emittance::SpecFixtures::FooWatcher.watch :bar, :hello
    Emittance::SpecFixtures::FooWatcher.watch :baz, :hello

    expect(Emittance::SpecFixtures::FooWatcher).to receive(:hello).exactly(3).times

    Emittance::SpecFixtures::FooEmitter.new.emit :foo
    Emittance::SpecFixtures::FooEmitter.new.emit :bar
    Emittance::SpecFixtures::FooEmitter.new.emit :baz
  end

  it 'runs for multiple listeners to multiple events' do
    Emittance::SpecFixtures::FooWatcher.watch :foo, :hello
    Emittance::SpecFixtures::FooWatcher.watch :bar, :hello
    Emittance::SpecFixtures::BarWatcher.watch :foo, :hello
    Emittance::SpecFixtures::BarWatcher.watch :bar, :hello

    expect(Emittance::SpecFixtures::FooWatcher).to receive(:hello).exactly(2).times
    expect(Emittance::SpecFixtures::BarWatcher).to receive(:hello).exactly(2).times

    Emittance::SpecFixtures::FooEmitter.new.emit :foo
    Emittance::SpecFixtures::FooEmitter.new.emit :bar
  end
end
