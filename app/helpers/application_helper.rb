require "addressable/uri"

module ApplicationHelper

  # I18n li link helper
  def i18n_li_link(lang)
    puts I18n.locale_names
    content_tag(:li, class: ((I18n.locale == lang) ? 'active' : nil )) do
      link_to I18n.locale_names[lang], url_for({ locale: lang })
    end
  end

  # Automatically set locale override for all url
  def url_for(options={})
    val = super
    if params[:locale].present?
      parsed = Addressable::URI.parse(val)
      if (parsed.query_values || {}).has_key?('locale')
        val
      else
        query_array = (parsed.query_values(Array) || []).delete_if do |item|
          item.kind_of?(Array) and item.first.to_s == "locale"
        end
        parsed.query_values = query_array << ['locale', params[:locale]]
        parsed.to_s
      end
    else
      val
    end
  end
end
