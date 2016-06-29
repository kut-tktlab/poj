require 'open3'
require 'shellwords'
require 'tempfile'

module Checkstyle
  def self.check_str(string)
    res = false

    Dir.mktmpdir('sketch') do |temp_dir|
      sketch_dir = "#{temp_dir}/Test"
      Dir.mkdir(sketch_dir)
      fname = "#{sketch_dir}/Test.pde"
      File.open(fname, 'w') { |f| f.print source }
      res = build(sketch_dir)
    end

    res
  def

  def self.check(path)
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
end
