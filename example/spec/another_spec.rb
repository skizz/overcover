require 'spec_helper'

describe 'Another Sample' do

  it 'should say hello again' do
    expect(Sample.new.say).to eq('Hello')
  end

  describe Overcover do

    # Some deep nested specs to ensure that we can collect coverage data effectively
    context 'nested context 1' do

      it 'still works' do
        expect(Sample.new.say).to eq('Hello')
      end

      context 'another nested context 2' do

        it 'still works' do
          expect(Sample.new.say).to eq('Hello')
        end

        context 'another nested context 3' do

          it 'still still works' do
            expect(Sample.new.say).to eq('Hello')
          end

          context 'another nested context 4' do

            it 'still still still works' do
              expect(Sample.new.say).to eq('Hello')
            end

          end
        end
      end
    end

  end

end