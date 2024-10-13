# Tendable Questionnaire

## Run

```sh
bundle
ruby questionnaire.rb
```

## Overview

The Tendable Questionnaire is a command-line Ruby application that collects user responses to a series of coding-related questions and calculates a rating based on the responses. The application uses PStore for data persistence.

## Features

- Asks users a set of questions about their coding skills in various programming languages.
- Validates user input (Yes/No).
- Stores user responses in a PStore database.
- Calculates and displays a rating based on user responses.
- Provides an average rating across all questionnaire runs.

## Requirements

- Ruby 2.5 or later
- Bundler (for managing dependencies)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/01aadesh/tendable-questionnaire.git
   cd tendable-questionnaire

## Test

```sh
rspec spec/questionnaire_spec.rb
```

## Running with Docker

1. Build the Docker image:

   ```sh
   docker build -t tendable-questionnaire .
   ```
2. Run the Docker container:

   ```sh
   docker run -it --rm tendable-questionnaire
   ```

