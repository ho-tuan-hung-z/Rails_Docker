# Use the official Ruby image
FROM ruby:3.2.2

# Install essential packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    apt-get install -y shared-mime-info

# Set the working directory
ENV DIR /var/www
RUN mkdir $DIR
WORKDIR $DIR

# Add the Gemfile and Gemfile.lock to the container
# Sử dụng COPY thay vì ADD cho file Gemfile, Gemfile.lock
COPY Gemfile Gemfile.lock $DIR/

# Set environment variables for Bundler
ENV BUNDLE_GEMFILE=$DIR/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle

# Install gems
RUN bundle install

# Add the rest of the application code
# Dùng COPY để thêm các tệp khác của ứng dụng vào container
COPY . $DIR

# Specify the default command to run on container start
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
