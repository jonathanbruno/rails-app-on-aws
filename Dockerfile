# Use official Ruby image as the base
FROM ruby:3.2.2

# Install dependencies

# Install Dependency -------------------------------------------

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential libvips libpq-dev \
    chrpath libssl-dev libxft-dev libfreetype6 \
    libfreetype6-dev libfontconfig1 libfontconfig1-dev \
    imagemagick file \
    fonts-liberation libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libatspi2.0-0 libcups2 libdbus-1-3 \
    libdrm2 libgbm1 libgtk-3-0 \
    libnspr4 libnss3 libxcomposite1 libxdamage1 \
    libxfixes3 libxkbcommon0 libxrandr2 xdg-utils \
    libjemalloc2 && rm -rf /var/lib/apt/lists/* 

# Set the working directory inside the container
WORKDIR /app

# Set environment to production
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=TRUE

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the entire app into the container
COPY . .

# Precompile assets for production
RUN bundle exec rake assets:precompile

# Expose port 3000 for the Rails app
EXPOSE 3000

RUN rails db:migrate
# Start the Rails server
#CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]