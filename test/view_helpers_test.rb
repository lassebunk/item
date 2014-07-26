require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include Item::ViewHelpers

  test "scope" do
    text = scope :aggregate_rating do
      "content"
    end

    assert_nil text
    assert_equal %{<div itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</div>},
                 output_buffer
  end

  test "prop" do
    concat prop(:aggregate_rating, "content")

    assert_equal %{<span itemprop="aggregateRating">content</span>},
                 output_buffer
  end

  test "hidden prop" do
    concat prop(aggregate_rating: "Rating content", title: "Title content")

    assert_equal %{<meta content="Rating content" itemprop="aggregateRating" />\n<meta content="Title content" itemprop="title" />},
                 output_buffer
  end

  test "link prop" do
    concat prop(:availability, :in_stock)

    assert_equal %{<link href="http://schema.org/InStock" itemprop="availability" />},
                 output_buffer
  end

  test "prop block" do
    text = prop :aggregate_rating do
      "content"
    end

    assert_nil text
    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">content</div>},
                 output_buffer
  end

  test "prop block with type" do
    text = prop :aggregate_rating, type: :other_type do
      "content"
    end

    assert_nil text
    assert_equal %{<div itemprop="aggregateRating" itemscope="itemscope" itemtype="http://schema.org/OtherType">content</div>},
                 output_buffer
  end

  test "combined" do
    text = scope :product do
      concat prop(:title, "My Title")
    end

    assert_nil text
    assert_equal %{<div itemscope="itemscope" itemtype="http://schema.org/Product"><span itemprop="title">My Title</span></div>},
                 output_buffer
  end
end
