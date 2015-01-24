require 'fallcli/uploader_browser_helper'
require 'dispel'

module FallCli
  module Middleware
    # Check if the client has set-up configuration yet.
    class UploaderBrowser < Base

      def show_ui filelist_obj
        ["\n", filelist_obj.show_files, "\nCurrent position: #{filelist_obj.position + 1} "].join("\n")
      end

      def get_files
        require 'find'
        files = []
        Find.find('.') do |e|
          if !File.directory?(e)
            files << e unless e.match /.git/
          end
        end
        files
      end

      def upload_file(file)
        puts "Would have uploaded #{file}"
      end

SPLASH = %{



             ';             .'
           ,':''           :',''
          '',,.:'         '',,,:',
        '',,,,..,'       '',,,,,.''
      .':,,,,,....'`    ';,,,,,,,..''
     '',,,,,,,.....',  ':,,,,,,,,...:'.
   ;',,,,,,,,,......''',,,,,,,,,,.....''
 `';,,,,,,,,,,.......',,,,,,,,,,,.......';
 ':,,,,,,,,,,,......```,,,,,,,,,,........'
  '',,,,,,,,,,.....`````,,,,,,,,,......,'`
   '',,,,,,,,,...`````````,,,,,,,.....:'
    :',,,,,,,,..```````````.,,,,,....''
     `',,,,,,,```````````````,,,,...';
       ':,,,.``````````````````,,..'.
        '',`````````````````````.,'`
        '::`````````````````````,.',
      `',,::,``````````````````:,..''
     :',,,::::```````````````:::,...''
    '',,,,::::,,```````````,::::,....:'
   ';,,,,,::::,,,.````````::::::,......'`
  ':,,,,,,::::,,,,,`` ``::::::::,.......':
 ':,,,,,,,::::,,,,,,. .;;:::::::,........'
  '',,,,,,::::,,,,,,.`;;::::::::,......;'`
   .';,,,,::::,,,,,,``,:::::::::,.....';
     '',,,::::,,,,,```,,::::::::,...''
      `';,:::,,,,,````,,,,::::::,.,':
        ;':::,,,..````,,,,,::::,,''
         '..:,,...````,,,,,,:::,.'
         '...,....````,,,,,,.:...'
         ;'.......````,,,,,,....''
           ''.....````,,,,,,..;'`
            :',...````,,,,,,,';
              ''`.````,,,,,''
               .':````,,,:',
                 ''```,,''
                  `';`;'.
                    :''

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

        sleep(2)

        files = get_files

        upload_browser = FallCli::UploaderBrowserHelper.new(files)

        Dispel::Screen.open do |screen|
          screen.draw show_ui(upload_browser)

          Dispel::Keyboard.output do |key|
            case key
            when :up then upload_browser.position_up
            when :down then upload_browser.position_down
            when :enter then upload_file(upload_browser.get_current_file)
            when "q" then break
            end
            screen.draw show_ui(upload_browser)
          end
        end

        @app.call(env)
      end
    end
  end
end