%w{
  version
  view_helpers
}.each do |file|
  require "item/#{file}"
end

ActionView::Base.send :include, Item::ViewHelpers