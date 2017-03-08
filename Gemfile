source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :staging do 
  gem 'puma'
  gem 'rails_12factor'
end

## library for push notification
gem 'pushmeup'
gem 'firebase'
gem 'fcm'

## Auth library
gem 'devise'

## schduler library
gem 'whenever', require: false

## event calendar
gem 'simple_calendar'

## make easy for nested form
gem "cocoon"

## object-based searching
gem 'ransack'

## file uploads
gem 'carrierwave'
gem 'mini_magick'

## paging
gem 'kaminari'

## bootstrap
gem 'bootstrap-sass'
gem 'bootstrap-kaminari-views'
gem 'bootstrap-sass-extras'

## datepicker bootstrap
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.42'

## rails slim
gem 'slim-rails'

## comment
gem 'acts_as_commentable_with_threading'

## routes on js
gem 'js-routes'

## cloud file upload
gem 'cloudinary'

## invite user
gem 'devise_invitable', '~> 1.7.0'

## background job
gem 'redis-rails', '~> 4'
gem 'sidekiq'

## jquery UI rails
gem 'jquery-ui-rails'

## gem for chart
gem 'chartkick'

## make id more prettier
gem 'friendly_id', '~> 5.1.0'

## ckeditor text area
gem 'ckeditor'

gem 'nprogress-rails'
gem 'dotenv-rails'
gem 'momentjs-rails', '>= 2.9.0'

## API
gem 'simple_token_authentication', '~> 1.0'
gem 'grape'
gem 'grape-entity', github: 'intridea/grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'

#dummy data
gem 'faker'
gem "fake_person", "~> 1.0"

## html to PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary-edge'

## error catcher
gem 'airbrake', '~> 5.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

## migration
gem 'migration_data'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'letter_opener_web', '~> 1.2.0'
  gem 'bullet'
  gem 'quiet_assets'
  gem 'annotate', github: 'ctran/annotate_models'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
end
