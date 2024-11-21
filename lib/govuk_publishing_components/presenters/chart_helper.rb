module GovukPublishingComponents
  module Presenters
    class ChartHelper
      def initialize(options)
        @rows = options[:rows]
        @keys = options[:keys]
        @minimal = options[:minimal]
        @enable_interactivity = true unless @minimal
        @hide_legend = options[:hide_legend]
        @point_size = options[:point_size] ||= 10
        @height = options[:height] || 400
        @h_axis_title = options[:h_axis_title]
        @v_axis_title = options[:v_axis_title]
        @text_position = "none" if @minimal
        @y_axis_view_window_min = 0
        @y_axis_view_window_min = "auto" if options[:y_axis_auto_adjust]
      end

      # config options are here: https://developers.google.com/chart/interactive/docs/gallery/linechart
      def chart_options
        {
          chartArea: { width: "80%", height: "60%" },
          crosshair: { orientation: "vertical", trigger: "both", color: "#ccc" },
          curveType: "none",
          enableInteractivity: @enable_interactivity,
          legend: legend_options,
          pointSize: @point_size,
          height: @height,
          tooltip: { isHtml: true },
          hAxis: {
            textStyle: set_font_16,
            title: @h_axis_title,
            titleTextStyle: set_font_19,
            textPosition: @text_position,
          },
          vAxis: {
            textStyle: set_font_16,
            title: @v_axis_title,
            titleTextStyle: set_font_19,
            textPosition: @text_position,
            viewWindow: {
              min: @y_axis_view_window_min,
            },
          },
        }
      end

      def chart_format_data
        if !@rows.empty? && !@keys.empty?
          @rows.map do |row|
            {
              name: row[:label],
              data: @keys.zip(row[:values]),
            }
          end
        end
      end

    private

      def legend_options
        return { position: "top", textStyle: set_font_16 } unless @hide_legend

        "none"
      end

      def set_font_16
        { color: "#000", fontName: "GDS Transport", fontSize: "16", italic: false }
      end

      def set_font_19
        { color: "#000", fontName: "GDS Transport", fontSize: "19", italic: false }
      end
    end
  end
end
