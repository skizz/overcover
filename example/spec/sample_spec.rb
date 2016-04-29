require 'spec_helper'

describe 'Sample' do

  it 'should say hello' do
    expect(Sample.new.say).to eq('Hello')
  end

  describe Overcover do

    # Some deep nested specs to ensure that we can collect coverage data effectively
    context 'nested context 1' do

      it 'works' do
        expect(Sample.new.say).to eq('Hello')
      end

      context 'nested context 2' do

        it 'works' do
          expect(Sample.new.say).to eq('Hello')
        end

        context 'nested context 3' do

          it 'works' do
            expect(Sample.new.say).to eq('Hello')
          end

          context 'nested context 4' do

            it 'works' do
              expect(Sample.new.say).to eq('Hello')
            end

          end
        end
      end
    end

  end

end