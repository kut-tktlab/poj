# coding: utf-8
require 'open3'
require 'shellwords'
require 'tempfile'
require 'stringio'

module Processing
  class Sketch
    PROCESSING_BIN = Pathname.new('processing-java')
    CHECKSTYLE_BIN = Rails.root.join('vendor', 'bin', 'checkstyle')

    class << self
      def from_source(source)
        temp_dir = Dir.mktmpdir('sketch')
        sketch_path = "#{temp_dir}/Test"
        Dir.mkdir(sketch_path)
        fname = "#{sketch_path}/Test.pde"
        File.open(fname, 'w') { |f| f.print source }

        Sketch.new(sketch_path)
      end
    end

    attr_reader :path, :main_class

    def initialize(path)
      @path = path
      @main_class = File.basename(path)
    end

    def build
      _, _, stderr, _ =
        Open3.popen3(
          PROCESSING_BIN.to_s, "--sketch=#{Shellwords.shellescape(@path)}", '--build')

      err = stderr.read.chop
      err.blank? ? nil : err
    end

    def check_style
      _, stdout, _, _ = Open3.popen3(CHECKSTYLE_BIN.to_s, Shellwords.shellescape(main_fname))

      err = stdout.read
      err.blank? ? nil : err
    end

    def main_fname
      File.join(@path, @main_class + '.pde')
    end
  end
end
