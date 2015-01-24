require 'fallcli/music_player_helper'
require 'dispel'
require 'audite'

module FallCli
  module Middleware
    # Check if the client has set-up configuration yet.
    class MusicPlayer < Base

      def show_ui filelist_obj
        ["\n", filelist_obj.show_files, "\nCurrent position: #{filelist_obj.position + 1} "].join("\n")
      end

SPLASH = %{

╔══╗ ♫
║██║ ♪♪
║██║♫♪
║ ◎♫♪♫
╚══╝ TURN DOWN FOR WHAT?

Volume: ▁ ▂ ▃ ▄ ▅ ▆ █ 11

______ ___   _      _     _____  _     _____
|  ___/ _ \\ | |    | |   /  __ \\| |   |_   _|
| |_ / /_\\ \\| |    | |   | /  \\/| |     | |
|  _||  _  || |    | |   | |    | |     | |
| |  | | | || |____| |___| \\__/\\| |_____| |_
\\_|  \\_| |_/\\_____/\\_____/\\____/\\_____/\\___/

V.#{FallCli::VERSION}
}

      def call(env)
        config = env["config"]

        say SPLASH

        songs = env['dropbox-client'].ls 'Music'

        browser = FallCli::BrowserHelper.new(songs)

        @player = Audite.new

        Dispel::Screen.open do |screen|
          screen.draw show_ui(browser)

          Dispel::Keyboard.output do |key|
            case key
            when :up then browser.position_up
            when :down then browser.position_down
            when :enter then
              @player.stop_stream

              file = browser.get_current_file
              file_basename = File.basename(file.path)

              fallcli_folder_location = '.fallcli/music/'

              download_folder = File.join(File.expand_path("~"), fallcli_folder_location)

              download_location = File.join(download_folder, file_basename)

              if !File.exist?(download_location)
                contents = env['dropbox-client'].download file.path
                File.open(download_location, 'w') {|f| f.write(contents) }
                say "MP3 downloaded to #{download_location}!"
              else
                say "MP3 already exists at #{download_location}!"
              end

              @player.load(download_location)

              @player.start_stream
            when "q" then break
            end
            screen.draw show_ui(browser)
          end
        end

        @app.call(env)
      end
    end
  end
end