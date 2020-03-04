module GovukPublishingComponents
  module Presenters
    class CheckboxesHelper
      include ActionView::Helpers
      include ActionView::Context

      attr_reader :items, :name, :css_classes, :list_classes, :error, :has_conditional,
                  :has_nested, :id, :hint_text, :description, :heading_size, :heading_caption

      def initialize(options)
        @items = options[:items] || []
        @name = options[:name]
        @css_classes = %w(gem-c-checkboxes govuk-form-group)
        @css_classes << "govuk-form-group--error" if options[:error]
        @css_classes << "govuk-checkboxes--small" if options[:small]
        @error = true if options[:error]

        @list_classes = %w(govuk-checkboxes gem-c-checkboxes__list)

        # check if any item is set as being conditional
        @has_conditional = options[:items].any? { |item| item.is_a?(Hash) && item[:conditional] }
        @has_nested = options[:items].any? { |item| item.is_a?(Hash) && item[:items] }

        @id = options[:id] || "checkboxes-#{SecureRandom.hex(4)}"
        @heading = options[:heading] || nil
        @heading_size = options[:heading_size]
        @heading_size = "m" unless %w(s m l xl).include?(@heading_size)
        @heading_caption = options[:heading_caption] || nil
        @is_page_heading = options[:is_page_heading]
        @description = options[:description] || nil
        @no_hint_text = options[:no_hint_text]
        @hint_text = options[:hint_text] || "Select all that apply." unless @no_hint_text
        @visually_hide_heading = options[:visually_hide_heading]
      end

      # should have a fieldset if there's a heading, or if more than one checkbox
      # separate check is in the view for if more than one checkbox and no heading, in which case fail
      def should_have_fieldset
        @items.length > 1 || @heading
      end

      def fieldset_describedby
        unless @no_hint_text
          text = %w()
          text << "#{id}-hint" if @hint_text
          text << "#{id}-error" if @error
          text
        end
      end

      def heading_markup
        return unless @heading.present?

        if @is_page_heading
          content_tag(
            :legend,
            class: "govuk-fieldset__legend govuk-fieldset__legend--xl gem-c-title",
          ) do
            concat content_tag(:span, heading_caption, class: "govuk-caption-xl") if heading_caption.present?
            concat content_tag(:h1, @heading, class: "gem-c-title__text")
          end
        else
          classes = %w(govuk-fieldset__legend)
          classes << "govuk-fieldset__legend--#{@heading_size}"
          classes << "gem-c-checkboxes__legend--hidden" if @visually_hide_heading

          content_tag(:legend, @heading, class: classes)
        end
      end

      def checkbox_markup(checkbox, index)
        checkbox_id = checkbox[:id] || "#{@id}-#{index}"
        controls = checkbox[:conditional].present? ? "#{checkbox_id}-conditional-#{index || rand(1..100)}" : checkbox[:controls]
        checkbox_name = checkbox[:name].present? ? checkbox[:name] : @name
        checked = true if checkbox[:checked].present?
        data = checkbox[:data_attributes] || {}
        data[:controls] = controls

        capture do
          concat check_box_tag checkbox_name, checkbox[:value], checked, class: "govuk-checkboxes__input", id: checkbox_id, data: data
          concat content_tag(:label, checkbox[:label], for: checkbox_id, class: "govuk-label govuk-checkboxes__label")
          concat content_tag(:span, checkbox[:hint], id: "#{checkbox_id}-item-hint", class: "govuk-hint govuk-checkboxes__hint") if checkbox[:hint]
        end
      end
    end
  end
end
