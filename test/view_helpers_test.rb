require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include Item::ViewHelpers

  test "scope" do
    content = scope :aggregate_rating do
      "content"
    end

    assert_equal %{<div itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</div>},
                 content
  end

  test "scope options" do
    content = scope :aggregate_rating, tag: :something, class: "some-class" do
      "content"
    end

    assert_equal %{<something class="some-class" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</something>},
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
    content = prop(aggregate_rating: "Rating content", title: "Title content")

    assert_equal %{<meta content="Rating content" itemprop="aggregateRating" />\n<meta content="Title content" itemprop="title" />},
                 content
  end

  test "link prop" do
    content = prop(:availability, :in_stock)

    assert_equal %{<link href="http://schema.org/InStock" itemprop="availability" />},
                 content
  end

  test "prop block" do
    content = prop :aggregate_rating do
      "content"
    end

    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</div>},
                 content
  end

  test "prop block with options" do
    content = prop :aggregate_rating, tag: :something, class: "some-class" do
      "content"
    end

    assert_equal %{<something class="some-class" itemprop="aggregateRating" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</something>},
                 content
  end

  test "prop block with type" do
    content = prop :aggregate_rating, type: :other_type do
      "content"
    end

    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="http://schema.org/OtherType">content</div>},
                 content
  end

  test "combined" do
    content = scope :product do
      concat prop(:title, "My Title")
    end

    assert_equal %{<div itemscope="itemscope" itemtype="http://schema.org/Product"><span itemprop="title">My Title</span></div>},
                 content
  end
end
