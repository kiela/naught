require 'spec_helper'

describe Naught::NullProxy do
  subject(:proxy) { Naught::NullProxy.new(object) }

  describe '__object__' do
    context 'with object as an empty array' do
      let(:object) { [] }

      context 'and calling .first.odd?' do
        it 'is a null object' do
          expect(proxy.first.odd?.__object__.inspect).to eq '<null>'
        end
      end

      context 'and calling .foo' do
        it 'raises a no method error' do
          expect { proxy.foo }.to raise_error(NoMethodError)
        end
      end
    end

    context 'with object as an array containing the element 1' do
      let(:object) { [1] }

      context 'and calling .first.odd?' do
        it 'is the actual value' do
          expect(proxy.first.odd?.__object__).to be true
        end
      end
    end

    context 'with a specific null class' do
      subject(:proxy) { Naught::NullProxy.new(object, null) }
      let(:null) { Naught.build { |config| config.define_explicit_conversions } }

      context 'and object as an empty array' do
        let(:object) { [] }

        context 'and calling .first.odd?' do
          it 'is an instance of the specific null class' do
            expect(proxy.first.odd?.__object__.class).to eq null
          end
        end
      end
    end
  end

  describe '#respond_to?' do
    context 'with object as an empty array' do
      let(:object) { [] }

      specify { expect(proxy).to respond_to(:size) }

      specify { expect(proxy).to respond_to(:__object__) }

      specify { expect(proxy).not_to respond_to(:foo) }
    end
  end
end

describe 'NullProxy()' do
  subject(:proxy) { NullProxy([]) }

  it 'returns an instance of NullProxy' do
    expect(proxy).to be_instance_of(Naught::NullProxy)
  end
end
