module Item
  module ViewHelpers
    def scope(key, options = {}, &block)
      tag = options.delete(:tag) || :div
      tag_options = { itemscope: true, itemtype: Util.itemtype(key) }.merge(options)
      content_tag(tag, tag_options, &block)
    end

    def prop(key, value = nil, options = {}, &block)
      if key.is_a?(Hash)
        key.map do |key, value|
          if value.is_a?(Symbol)
            link_prop(key, value)
          else
            meta_prop(key, value)
          end
        end.join("\n").html_safe
      elsif value.is_a?(Symbol)
        link_prop(key, value)
      else
        options, value = value, nil if value.is_a?(Hash)
        itemprop = Util.itemprop(key)

        if block
          tag = options.delete(:tag) || :div
          itemtype = Util.itemtype(options.delete(:type) || key)
          tag_options = { itemprop: itemprop, itemscope: true, itemtype: itemtype }.merge(options)
          content_tag(tag, tag_options, &block)
        else
          tag = options.delete(:tag) || :span
          tag_options = { itemprop: itemprop }.merge(options)
          content_tag(tag, value, tag_options)
        end
      end
    end

    def link_prop(key, value)
      tag(:link, itemprop: Util.itemprop(key), href: Util.href(value))
    end

    def meta_prop(key, value)
      tag(:meta, itemprop: Util.itemprop(key), content: value)
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