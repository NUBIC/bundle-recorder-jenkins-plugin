$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'rspec'

require 'bundler'
Bundler.setup

require 'init_classpath'
BundleRecorder::Spec::Classpath.init

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  def tmpdir(*path)
    if path.empty?
      @tmpdir ||= Pathname.new(File.expand_path('../tmp', __FILE__)).
        tap { |p| p.mkpath }
    else
      path.inject(tmpdir) { |p, sub| p + sub }.tap { |p| p.mkpath }
    end
  end

  def file_path(path)
    Java.hudson.FilePath.new java_file(path.to_s)
  end

  def java_file(path)
    java.io.File.new path.to_s
  end
end
