require 'fallcli/music_player_helper'
require 'dispel'

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

        music_player = FallCli::MusicPlayerHelper.new(songs)

        Dispel::Screen.open do |screen|
          screen.draw show_ui(music_player)

          Dispel::Keyboard.output do |key|
            case key
            when :up then music_player.position_up
            when :down then music_player.position_down
            when :enter then music_player.play
            when "q" then break
            end
            screen.draw show_ui(music_player)
          end
        end

        @app.call(env)
      end
    end
  end
end