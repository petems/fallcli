module FallCli
  class BrowserHelper
    attr_accessor :position

    def initialize items
      @files = Array.new
      items.each { |item| @files << item }
      @position = 0
    end

    def get_current_file
      @files[@position]
    end

    def show_files
      @files.each_with_index.map do |item, index|
        position == index ? "[#{pretty_dropbox_file(item)}]" : " #{pretty_dropbox_file(item)} "
      end
    end

    def pretty_dropbox_file file
      "#{file.path} | #{file.mime_type} | #{file.size}"
    end

    def position_up
      @position -= 1 unless @position < 1
    end

    def position_down
      @position += 1 unless @position == (@files.size - 1)
    end
  end
end