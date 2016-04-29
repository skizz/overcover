require 'spec_helper'

describe Overcover do
  it 'has a version number' do
    expect(Overcover::VERSION).not_to be nil
  end

  # Some deep nested specs to ensure that we can collect coverage data effectively
  context 'nested context 1' do

    it 'works' do
      expect(Overcover::VERSION).not_to be nil
    end

    context 'nested context 2' do

      it 'works' do
        expect(Overcover::VERSION).not_to be nil
      end

      context 'nested context 3' do

        it 'works' do
          expect(Overcover::VERSION).not_to be nil
        end

        context 'nested context 4' do

          it 'works' do
            expect(Overcover::VERSION).not_to be nil
          end

        end
      end
    end
  end

end
