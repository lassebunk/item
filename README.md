[![Build Status](https://secure.travis-ci.org/lassebunk/item.png)](http://travis-ci.org/lassebunk/item)

# Item

Item is a Ruby on Rails plugin for adding semantic markup (microdata) to your views without cluttering the view code.

**What is Microdata?** [Microdata](https://schema.org) helps search engines show additional information about your content, for example product reviews.
This can help attract visitors to your site:

![Microdata in SERPs](http://i.imgur.com/bCi0GHF.png)

**The problem with Microdata:** Normally, implementing these Microdata can make your views quite messy because you have a lot of "extra" content other than your regular view content.

**Item:** Item solves the problem by adding two helpers, `scope` and `prop`, that you can use in your views.
This makes it easy to add microdata scopes and properties without cluttering the view. Item is made to maximize ease of writing (and joy, of course – it *is* Ruby), while minimizing the code needed to add microdata to your views.

## Installation

Add this line to your application's *Gemfile*:

```ruby
gem 'item'
```

Then run:

```bash
$ bundle
```

## Usage

### Scopes

To define an `itemscope`:

```erb
<%= scope :product do %>
  ...
<% end %>
```

The above will generate the following HTML:

```html
<div itemscope itemtype="https://schema.org/Product">
  ...
</div>
```

If you need the scope to be another tag than `<div>` or e.g. need to set a class, you can do it like this:

```erb
<%= scope :product, tag: :span, class: "a-class" do %>
  ...
<% end %>
```

### Properties

To define an `itemprop` span:

```erb
<%= prop :name, "My Product Name" %>
```

This will generate the following HTML:

```html
<span itemprop="name">My Product Name</span>
```

If you need the property to be another tag than span `<span>` or e.g. need to set a class, you can do it like this:

```erb
<%= prop :name, "My Product Name", tag: :div, class: "a-class" %>
```

#### Scoped properties

To define a property that is also a scope:

```erb
<%= prop :review do %>
  <%= prop :name, "Pete Anderson" %>
<% end %>
```

The above will generate the following HTML:

```html
<div itemprop="review" itemscope itemtype="https://schema.org/Review">
  <span itemprop="name">Pete Anderson</span>
</div>
```

##### Defining types on scoped properties

Sometimes you need to define a type on scoped properties when this cannot be inferred from the property name. To set a type:

```erb
<%= prop :review_rating, type: :rating do %>
  ...
<% end %>
```

This will generate the following HTML:

```html
<div itemprop="reviewRating" itemscope itemtype="https://schema.org/Review">
  ...
</div>
```

##### Disabling rendering on scoped properties

Sometimes you need to disable rendering on entire `prop` blocks. You can do this by passing `:if` and `:unless` options.
This will render the content, but without microdata for both the `prop` block itself and all `prop`s inside it:

```erb
<%= prop :review_rating, type: :rating, if: @product.rating? do %>
  ...
<% end %>
```

#### Meta properties

To define hidden `itemprop`s via `<meta>` tags, pass a hash to the `prop` helper:

```erb
<%= prop date_published: Date.today %>
```

This will generate the following HTML:

```html
<meta itemprop="datePublished" content="2014-07-26" />
```

#### Link properties

To define a link to an enumeration member, e.g. [ItemAvailability](https://schema.org/ItemAvailability):

```erb
<%= prop :availability, :in_stock %>
```

You can also do this by passing symbols as hash values:

```erb
<%= prop availability: :in_stock %>
```

This will generate the following HTML:

```html
<link itemprop="availability" href="https://schema.org/InStock" />
```

## Example

The following is based on the [Product example](https://schema.org/Product) on [Schema.org](https://schema.org), rewritten with the Item gem. In your view:

```erb
<% scope :product do %>
  <%= itemprop :name, "Kenmore White 17\" Microwave" %>
  <%= image_tag "kenmore-microwave-17in.jpg" %>

  <%= prop :aggregate_rating do %>
    Rated <%= prop :rating_value, 3.5 %>/5
    based on <%= prop :review_count, 11 %> custom reviews
  <% end %>

  <%= prop :offers, type: :offer do %>
    <%= prop :price, "$55.00" %>
    <%= prop :availability, :in_stock %>
    In Stock
  <% end %>

  Product description:
  <%= prop :description, "0.7 cubic feet countertop microwave.
    Has six preset cooking categories and convenience features like
    Add-A-Minute and Child Lock." %>

  Customer reviews:
  <%= prop :review do %>
    <%= prop :name, "Not a happy camper" %> -
    by <%= prop :author, "Ellie" %>,
    <%= prop date_published: "2011-04-01" %>
    April 1, 2011
    <%= prop :review_rating, type: :rating do %>
      <%= prop worst_rating: 1 %>
      <%= prop :rating_value, 1 %> /
      <%= prop :best_rating, 5 %> stars
      <%= prop :description, "The lamp burned out and now I have to replace it." %>
    <% end %>
  <% end %>
<% end %>
```

## Tools for validating microdata

There are various tools you can use for validating your microdata.
I recommend using these (especially Google's) before releasing to production, so you are sure that the microdata you implemented works as expected.

#### Google Structured Data Testing Tool

[Google's Structured Data Testing Tool](https://www.google.com/webmasters/tools/richsnippets) is the tool I recommend using for making sure your microdata will validate.
If your microdata validates here, it will validate on Google SERPs.

You can enter a URL or copy/paste HTML to validate. This means that you can test your development code, too.

#### Bing Markup Validator

[Bing's Markup Validator](https://www.bing.com/webmaster/diagnostics/markup/validator) appears to be easier to read, but it is not as strict as Google's tool.

#### Mida

[Mida](https://github.com/LawrenceWoodman/mida) is a great tool for validating your code locally as you implement new microdata.
It runs locally via the command line and takes a URL to validate, so you can validate code on your local development server.

## Contributing

Changes and improvements are to Item are very welcome and greatly appreciated.

1. Fork the project
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your changes, including tests so we don't break it unintentionally.
4. Run `rake` to make sure the tests pass
5. Commit your changes (`git commit -am 'Add feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new pull request