require 'fallcli/uploader_browser_helper'
require 'ruby-progressbar'
require 'dispel'
require 'pathname'

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
            when :enter then
              file = upload_browser.get_current_file
              file_name = File.basename(file)
              filepath = Pathname.new(file).realpath.to_s
              total_size = File.size(filepath)
              contents  = File.read(filepath)

              if total_size < 5000000
                env['dropbox-client'].upload file_name, contents
              else
                say "Larger than 5MB: Progress Upload"

                upload_progress_bar = ::ProgressBar.create(:title => "Upload progress",
                  :format => '%a <%B> %p%% %t',
                  :starting_at => 0,
                  :total => total_size)

                response = env['dropbox-client'].chunked_upload File.open(filepath), contents do |offset, upload|
                  upload_progress_bar.progress = offset
                end
              end

              say "File uploaded successfully!"
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