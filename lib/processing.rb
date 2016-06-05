require 'open3'

module Processing
  # Processing スケッチをビルドする
  def self.build(sketch_path)
    _, _, stderr, _ = Open3.popen3("processing-java --sketch=\"#{sketch_path}\" --build")
    stderr.read.blank?
  end
end
