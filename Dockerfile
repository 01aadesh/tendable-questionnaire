# Use the official Ruby image
FROM ruby:2.7

# Set the working directory
WORKDIR /usr/src/app

# Copy the Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Command to run the application
CMD ["ruby", "questionnaire.rb"]

# Command to run the tests
CMD ["rspec", "spec"]
