# coding: utf-8
require 'open3'
require 'shellwords'

module Processing
  # Processing スケッチをビルドする
  def self.build(sketch_path)
    _, _, stderr, _ =
      Open3.popen3(
        'processing-java',"--sketch=#{Shellwords.shellescape(sketch_path)}", '--build')
    stderr.read.blank?
  end
end
