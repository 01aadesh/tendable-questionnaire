# spec/questionnaire_spec.rb

require 'pstore'
require 'rspec'
require_relative '../questionnaire'  # Adjust the path as needed

RSpec.describe 'Tendable Questionnaire' do
  let(:store) { PStore.new("test.pstore") }

  before do
    # Clear store before each test
    store.transaction { store[:responses] = nil; store[:ratings] = [] }
  end

  describe '#do_prompt' do
    before do
      responses = ["yes\n", "no\n", "yes\n", "no\n", "yes\n"]
      allow($stdin).to receive(:gets).and_return(*responses)
    end

    it 'stores user responses in the store' do
      do_prompt(store)

      store.transaction(true) do
        expect(store[:responses]).not_to be_nil
        puts store[:responses]
        expect(store[:responses]["q1"]).to be true
        expect(store[:responses]["q2"]).to be false
        expect(store[:responses]["q3"]).to be true
        expect(store[:responses]["q4"]).to be false
        expect(store[:responses]["q5"]).to be true
      end
    end
  end

  describe '#do_report' do
    before do
      store.transaction do
        store[:responses] = {
          "q1" => true,
          "q2" => false,
          "q3" => true,
          "q4" => false,
          "q5" => true
        }
      end
    end

    it 'displays user responses and calculates the rating' do
      expect { do_report(store) }.to output(/Your Responses:/).to_stdout
      expect { do_report(store) }.to output(/Your Rating: 60.0/).to_stdout
      expect { do_report(store) }.to output(/Average Rating across all runs:/).to_stdout
    end

    it 'stores the calculated rating in the store' do
      do_report(store)

      store.transaction(true) do
        expect(store[:ratings]).to include(60.0)
      end
    end
  end

  describe '#get_answer' do
    it 'returns true for valid yes answers' do
      allow($stdin).to receive(:gets).and_return("yes\n")
      expect(get_answer("Can you code in Ruby?")).to be true
    end

    it 'returns false for valid no answers' do
      allow($stdin).to receive(:gets).and_return("no\n")
      expect(get_answer("Can you code in Java?")).to be false
    end

    it 're-prompts for invalid answers' do
      allow($stdin).to receive(:gets).and_return("invalid\n", "yes\n")
      expect(get_answer("Can you code in Swift?")).to be true
    end
  end

  describe '#calculate_rating' do
    it 'calculates the correct rating' do
      answers = [true, false, true, false, true]
      expect(calculate_rating(answers)).to eq(60.0)
    end
  end

  describe '#average_rating' do
    it 'calculates the average rating' do
      store.transaction do
        store[:ratings] = [100.0, 60.0]
      end
      expect(average_rating(store)).to eq(80.0)
    end

    it 'returns 0 if there are no ratings' do
      expect(average_rating(store)).to eq(0)
    end
  end
end
