module Item
  module ViewHelpers
    def scope(key, options = {}, &block)
      content = capture(&block)
      concat content_tag(:div, content, itemscope: "itemscope", itemtype: Util.itemtype(key))
      nil
    end

    def prop(key, value = nil, options = {}, &block)
      if key.is_a?(Hash)
        key.map { |key, value| tag(:meta, itemprop: Util.itemprop(key), content: value) }.join("\n").html_safe
      elsif value.is_a?(Symbol)
        tag(:link, itemprop: Util.itemprop(key), href: Util.href(value))
      else
        options, value = value, nil if value.is_a?(Hash)
        itemprop = Util.itemprop(key)

        if block
          value = capture(&block)
          itemtype = Util.itemtype(options[:type].presence || key)
          concat content_tag(:div, value, itemprop: itemprop, itemscope: "itemscope", itemtype: itemtype)
          nil
        else
          content_tag(:span, value, itemprop: itemprop)
        end
      end
    end

    module Util
      class << self
        def itemtype(name)
          href(name)
        end

        def itemprop(name)
          name.to_s.gsub(/_(.)/) { $1.upcase }
        end

        def href(name)
          name = name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
          "http://schema.org/#{name}"
        end
      end
    end
  end
end