require 'rails_helper'

describe PPA::SourceMappers::Base do

  # dummy class para teste de classe básica - BaseSourceMapper - definir a constante (classe)
  source_mapper_class = Class.new(described_class) do
    maps Hash, to: OpenStruct

    def map
      target = OpenStruct.new source
    end
  end

  describe '::new' do
    it 'raises RuntimeError if ::maps method was not used to configure source_mapper class' do
      unconfigured_source_mapper_class = Class.new(described_class)
      expect { unconfigured_source_mapper_class.new(1) }.to raise_error RuntimeError
    end

    it 'raises TypeError if source argument is not from defined source_class' do
      expect { source_mapper_class.new(1) }.to raise_error TypeError
    end
  end

  describe '::map' do
    let!(:source) { { a: 1, b: 2 } }
    subject(:map) { source_mapper_class.map source }

    it 'creates an OpenStruct with source Hash values' do
      target = map
      expect(target.a).to eq source[:a]
      expect(target.b).to eq source[:b]
    end
  end

  describe '::map_all' do
    let!(:source_scope) { [{ a: 1, b: 2 }, { c: 3, d: 4 }] }
    subject(:map_all) { source_mapper_class.map_all scope: source_scope, with: :each }

    it 'creates an OpenStruct for each Hash in scope' do
      source_scope.each do |source_hash|
        expect(OpenStruct).to receive(:new).with(source_hash)
      end

      map_all
    end
  end


  describe 'blacklisting' do
    blacklisting_mapper_class = Class.new(described_class) do
      maps Hash, to: :OpenStruct

      def map
        target = OpenStruct.new source
      end

      def blacklisted?
        source[:ignore]
      end
    end

    let!(:source) { { content: 'something' } }
    let!(:mapper) { blacklisting_mapper_class.new source }
    subject(:map) { mapper.map }

    context 'when #blacklisted? returns true' do
      # ensuring blacklist condition is met
      before { source[:ignore] = true }

      it 'halts execution of #map' do
        expect(OpenStruct).not_to receive(:new)

        expect(mapper).to be_blacklisted
        map
      end
    end

    context 'when #blacklisted? returns false' do
      # ensuring blacklist condition is not met
      before { source.delete(:ignore) if source.key?(:ignore) }

      it 'process with the execution of #map' do
        expect(OpenStruct).to receive(:new)

        expect(mapper).not_to be_blacklisted
        map
      end
    end

  end

end
