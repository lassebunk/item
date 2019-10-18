module Item
  module ViewHelpers
    def scope(key, options = {}, &block)
      tag = options.delete(:tag) || :div
      tag_options = { itemscope: "itemscope", itemtype: Util.itemtype(key) }.merge(options)
      content_tag(tag, tag_options, &block)
    end

    def prop(key, value = nil, options = {}, &block)
      @_item_enabled = true unless defined?(@_item_enabled)

      if key.is_a?(Hash)
        key.map do |key, value|
          if value.is_a?(Symbol)
            link_prop(key, value) if @_item_enabled
          else
            meta_prop(key, value) if @_item_enabled
          end
        end.compact.join("\n").html_safe
      elsif value.is_a?(Symbol)
        link_prop(key, value) if @_item_enabled
      else
        options, value = value, nil if value.is_a?(Hash)
        itemprop = Util.itemprop(key)

        item_enabled_old = @_item_enabled
        @_item_enabled = item_enabled_old && options.fetch(:if, !options.fetch(:unless, false))
        
        options.delete(:if)
        options.delete(:unless)

        content = if block
          tag = options.delete(:tag) || :div
          itemtype = Util.itemtype(options.delete(:type) || key)
          options = { itemprop: itemprop, itemscope: "itemscope", itemtype: itemtype }.merge(options) if @_item_enabled
          content_tag(tag, options, &block)
        else
          tag = options.delete(:tag) || :span
          options = { itemprop: itemprop }.merge(options) if @_item_enabled
          content_tag(tag, value, options)
        end

        @_item_enabled = item_enabled_old

        content
      end
    end

    private

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
          "https://schema.org/#{name}"
        end
      end
    end
  end
end