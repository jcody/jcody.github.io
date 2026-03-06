require "favicon_maker"

# Patch favicon_maker to use `magick` instead of the deprecated `convert`
# command (removed in ImageMagick v7).

module FaviconMaker
  module BaseCommand
    def compose(template_file_path, output_file_path, convert_settings, options, format, &block)
      ico_cmd =   [ "magick -background none #{options}".strip ]
      ico_cmd +=  [ "\"#{template_file_path}\" #{options_to_args(convert_settings)}" ]
      ico_cmd +=  yield([]) if block_given?
      ico_cmd +=  [ " #{format}:\"#{output_file_path}\"" ]
      @command = ico_cmd.join(' ')
    end
  end

  class Creator
    private

    def fetch_image_magick_version
      (`magick --version`).scan(/ImageMagick (\d\.\d\.\d)/).flatten.first
    end
  end
end
