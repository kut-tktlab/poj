# coding: utf-8
require 'open3'
require 'shellwords'
require 'tempfile'

module Processing
  def self.build_str(source)
    res = false

    Dir.mktmpdir('sketch') do |temp_dir|
      sketch_dir = "#{temp_dir}/Test"
      Dir.mkdir(sketch_dir)
      fname = "#{sketch_dir}/Test.pde"
      File.open(fname, 'w') { |f| f.print source }
      res = build(sketch_dir)
    end

    res
  end

  # Processing スケッチをビルドする
  def self.build(sketch_path)
    _, _, stderr, _ =
      Open3.popen3(
        'processing-java',"--sketch=#{Shellwords.shellescape(sketch_path)}", '--build')

    err = stderr.read
    err.blank?
  end
end
