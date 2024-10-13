require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# TODO: FULLY IMPLEMENT
def do_prompt(store)
  responses = {}
  # Ask each question and get an answer from the user's input.
  QUESTIONS.each_key do |question_key|
    ans = get_answer(QUESTIONS[question_key])
    responses[question_key] = ans
  end

  # Save responses to PStore
  store.transaction do
    store[:responses] = responses
  end
end

def do_report(store)
  rating = 0.0
  # Retrieve responses from PStore
  store.transaction(true) do
    responses = store[:responses]

    if responses.nil?
      puts "No responses found."
      return
    end

    puts "\nYour Responses:"
    responses.each do |key, answer|
      puts "#{QUESTIONS[key]} - Answer: #{answer}"
    end
    rating = calculate_rating(responses.values)
  end

  store.transaction do
    store[:ratings] ||= []
    store[:ratings] << rating
  end

  puts "\nYour Rating: #{rating}"
  puts "Average Rating across all runs: #{average_rating(store)}"
end

def get_answer(question)
  loop do
    print "#{question} (Yes/No/Y/N): "
    answer = gets
    return false if answer.nil?
    answer = answer.chomp.strip.downcase
    return true if %w[yes y].include?(answer)
    return false if %w[no n].include?(answer)
    puts "Invalid answer. Please respond with 'Yes', 'No', 'Y', or 'N'."
  end
end

def calculate_rating(answers)
  yes_count = answers.count(true)
  total_questions = answers.size
  total_questions.zero? ? 0 : (100.0 * yes_count / total_questions).round(2)
end

def average_rating(store)
  store.transaction(true) do
    ratings = store[:ratings] || []
    return 0 if ratings.empty?

    # Use inject to calculate the sum of ratings
    total = ratings.inject(0) { |sum, rating| sum + rating }
    (total / ratings.size.to_f).round(2)
  end
end

do_prompt(store)
do_report(store)
