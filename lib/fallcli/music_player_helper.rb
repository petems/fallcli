require 'fallcli/browser_helper'
require 'audite'

module FallCli
  class MusicPlayerHelper < FallCli::BrowserHelper

    def play
      @player = Audite.new

      load(@files.first)
      @player.start_stream
    end

    def load(track)
      @folder = File.expand_path("~/.fallcli/music/")

      Dir.mkdir(@folder) unless File.exist?(@folder)

      mp3_name = @files.first

      @file = "#{@folder}/#{mp3_name}.mp3"

      if !File.exist?(@file.first)

        download_contents = env['dropbox-client'].download @file.first.path

        File.open(File.join(@folder,@file.first.path), 'w') {|f| f.write(contents) }
      else
        say "File already downloaded"
      end

      @player.load(@file)
    end

  end
end