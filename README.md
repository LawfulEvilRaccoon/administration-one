# Administration One

Administration One is a fork of [Administration Zero by Lázaro Nixon](https://github.com/lazaronixon/administration-zero), which can be considered as its charged and production-ready version. Like the original gem, it is designed for generating an administrative interface for Ruby on Rails applications. Administration-One includes all the original gem’s features but also comes with the following:

* User management is built with the standard Rails authorization generator introduced in version 8+. Administrators are users with the `is_admin` field set to `true`.
* EditorJS as the WYSIWYG editor.
* Basic user profile management.
* A functional light/dark theme switcher and other minor improvements.

<img src=".documentation/screenshot.png" alt="screenshot" style="max-width: 100%;">

## Installation

```ruby
bundle add administration-one
```

Then: 

```
rails generate admin:install
```

Then run `bundle install`

Then run `rails db:migrate db:seed`

You can access the admin panel in `/admin`, using `email: "admin@example.com", password: "Password1234"`

## Scaffolding

You'll need to create a model to be administrated, if you don't have one. for this example let's use the following:

```
rails generate model Post title:string content:text published:boolean
```

Now you are free to generate your admin scaffolds.

```
rails generate admin:scaffold posts title:string content:text published:boolean
```

Since this model has an attribute `content:text`, the generator will ask whether to use EditorJS. This question will be asked for any model that has an attribute named «content». 

## A few words about EditorJS

Since uploading images via EditorJS typically requires storage (which can be implemented in many different ways depending on the project) Administration One uses an universal solution: encoding all images to Base64. However, this approach may be not database-friendly. The author strongly recommends implementing file-based image uploads tailored to your project’s specific.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
