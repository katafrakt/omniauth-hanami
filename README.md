# Omniauth::Hanami

This is a provider for OmniAuth for (not only) Hanami applications. It's a very thin authentication library that does only authentication and nothing more.

**Why would you want it?**

* It makes almost no assumptions (apart from using Warden).
* You can have any database schema you want.
* You can choose our favourite hashing algorithm, be it BCrypt, SCrypt, Argon2 or even MD5 (or plaintext; equally secure).
* `hanami/model` is not required. You can use what you want, for example load users from YAML file or even external API (although this is probably not the best idea).
* It integrates seamlessly with other OmniAuth solution. You can start with Github authentication and add this later. Or if you want to add Facebook auth later, it's a no-brainer.

**What it's not:**

* Devise. It does not have methods to handle registration, confirmation, locking etc. for you. You have to write all of this by yourself. But on the other hand, this is usually a good thing, as you don't need to hack around what an "advanced library" does not let you do easily.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-hanami'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-hanami

## Usage

First of all, you need an interactor which takes auth key (e.g. email) + password and returns user object if it's sucessfully authenticated or fails otherwise. A common example would be:

```ruby
require 'hanami/interactor'

class FindUserForAuth
  include Hanami::Interactor

  expose :user

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    user = UserRepository.new.find_by_email(@login)
    if user && SCrypt::Password.new(user.crypted_password) == @password
      @user = user
    else
      fail!
    end
  end
end
```

Next, configure Warden and OmniAuth in your `apps/web/application.rb`:

```ruby
middleware.use Warden::Manager do |manager|
  # manager.failure_app = Web::Controllers::Session::Failure.new
end
middleware.use OmniAuth::Builder do
  provider :hanami, interactor: FindUserForAuth
end
```

And add this to `routes.rb` (this is ugly and will change when I find out how – or maybe you can help?):

```ruby
post '/auth/:provider/callback', to: 'session#create'
get '/auth/:provider/callback', to: 'session#create'
```

All that's left is a form that sends POST to `/auth/hanami/callback`. Like this:

```ruby
form_for :user, '/auth/hanami/callback' do
  fieldset do
    div do
      label :email
      text_field :email, type: 'email'
    end
    div do
      label :password
      password_field :password
    end
    div do
      submit 'Sign in'
    end
  end
end
```

To access your signed in user, you can use this code in the controller:

```ruby
def current_user
  @current_user ||= warden.user
end

def warden
  request.env['warden']
end
```

### Configuration options

`interactor` option is mandatory for gem to work, but you can also provide others:

| option | descriptions | default |
|--------|--------------|---------|
| `auth_key` | How to get auth key from params | `->(params) { params['user']['email'] }` |
| `password` | How to get password from params | `->(params) { params['user']['password'] }` |

Example:

```ruby
middleware.use OmniAuth::Builder do
  provider :hanami, 
      interactor: FindUserForAuth, 
      auth_key: ->(params) { params['login_or_email'] }, 
      password: ->(params) { params['password'] + '1234' }
end
```

### Sample application

You can see it [here](https://gitlab.com/katafrakt/hanami_omniauth_example).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katafrakt/omniauth-hanami.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

