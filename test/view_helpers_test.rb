require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include Item::ViewHelpers

  test "scope" do
    content = scope :aggregate_rating do
      "content"
    end

    assert_equal %{<div itemscope="itemscope" itemtype="https://schema.org/AggregateRating">content</div>},
                 content
  end

  test "scope options" do
    content = scope :aggregate_rating, tag: :something, class: "some-class" do
      "content"
    end

    assert_equal %{<something class="some-class" itemscope="itemscope" itemtype="https://schema.org/AggregateRating">content</something>},
                 content
  end

  test "prop" do
    content = prop(:aggregate_rating, "content")

    assert_equal %{<span itemprop="aggregateRating">content</span>},
                 content
  end

  test "prop options" do
    content = prop(:aggregate_rating, "content", tag: :something, class: "some-class")

    assert_equal %{<something class="some-class" itemprop="aggregateRating">content</something>},
                 content
  end

  test "hidden prop" do
    content = prop(aggregate_rating: "Rating content", availability: :in_stock)

    assert_equal %{<meta content="Rating content" itemprop="aggregateRating" />\n<link href="https://schema.org/InStock" itemprop="availability" />},
                 content
  end

  test "link prop" do
    content = prop(:availability, :in_stock)

    assert_equal %{<link href="https://schema.org/InStock" itemprop="availability" />},
                 content
  end

  test "prop block" do
    content = prop :aggregate_rating do
      "content"
    end

    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="https://schema.org/AggregateRating">content</div>},
                 content
  end

  test "prop block with options" do
    content = prop :aggregate_rating, tag: :something, class: "some-class" do
      "content"
    end

    assert_equal %{<something class="some-class" itemprop="aggregateRating" itemscope="itemscope" itemtype="https://schema.org/AggregateRating">content</something>},
                 content
  end

  test "prop block with type" do
    content = prop :aggregate_rating, type: :other_type do
      "content"
    end

    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="https://schema.org/OtherType">content</div>},
                 content
  end

  test "combined" do
    content = scope :product do
      prop(:title, "My Title")
    end

    assert_equal %{<div itemscope="itemscope" itemtype="https://schema.org/Product"><span itemprop="title">My Title</span></div>},
                 content
  end

  test "prop with trueish if" do
    content = scope :product do
      prop :offers, type: :offer, tag: :custom1, class: "offers-container", if: "trueish" do
        [prop(:price, 123.5, tag: :custom2, class: "price-container"),
         prop(availability: :in_stock, price_currency: "DKK"),
         prop(:other_key, :other_value)].join.html_safe
      end
    end

    assert_equal %{<div itemscope="itemscope" itemtype="https://schema.org/Product"><custom1 class="offers-container" itemprop="offers" itemscope="itemscope" itemtype="https://schema.org/Offer"><custom2 class="price-container" itemprop="price">123.5</custom2><link href="https://schema.org/InStock" itemprop="availability" />\n<meta content="DKK" itemprop="priceCurrency" /><link href="https://schema.org/OtherValue" itemprop="otherKey" /></custom1></div>},
                 content
  end

  test "prop with falsey if" do
    content = scope :product do
      "".tap do |content|
        content << prop(:offers, type: :offer, tag: :custom1, class: "offers-container", if: nil) do
          [prop(:price, 123.5, tag: :custom2, class: "price-container"),
           prop(availability: :in_stock, price_currency: "DKK"),
           prop(:other_key, :other_value)].join.html_safe
        end
        content << prop(:name, "Product Name")
      end.html_safe
    end

    assert_equal %{<div itemscope=\"itemscope\" itemtype=\"https://schema.org/Product\"><custom1 class=\"offers-container\"><custom2 class=\"price-container\">123.5</custom2></custom1><span itemprop=\"name\">Product Name</span></div>},
                 content
  end

  test "prop with falsey unless" do
    content = scope :product do
      prop :offers, type: :offer, tag: :custom1, class: "offers-container", unless: nil do
        [prop(:price, 123.5, tag: :custom2, class: "price-container"),
         prop(availability: :in_stock, price_currency: "DKK"),
         prop(:other_key, :other_value)].join.html_safe
      end
    end

    assert_equal %{<div itemscope="itemscope" itemtype="https://schema.org/Product"><custom1 class="offers-container" itemprop="offers" itemscope="itemscope" itemtype="https://schema.org/Offer"><custom2 class="price-container" itemprop="price">123.5</custom2><link href="https://schema.org/InStock" itemprop="availability" />\n<meta content="DKK" itemprop="priceCurrency" /><link href="https://schema.org/OtherValue" itemprop="otherKey" /></custom1></div>},
                 content
  end

  test "prop with trueish unless" do
    content = scope :product do
      "".tap do |content|
        content << prop(:offers, type: :offer, tag: :custom1, class: "offers-container", if: nil) do
          [prop(:price, 123.5, tag: :custom2, class: "price-container"),
           prop(availability: :in_stock, price_currency: "DKK"),
           prop(:other_key, :other_value)].join.html_safe
        end
        content << prop(:name, "Product Name")
      end.html_safe
    end

    assert_equal %{<div itemscope=\"itemscope\" itemtype=\"https://schema.org/Product\"><custom1 class=\"offers-container\"><custom2 class=\"price-container\">123.5</custom2></custom1><span itemprop=\"name\">Product Name</span></div>},
                 content
  end
end
