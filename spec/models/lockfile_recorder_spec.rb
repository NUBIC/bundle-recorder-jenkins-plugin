require 'spec_helper'

require 'models/lockfile_recorder'

describe LockfileRecorder do
  let(:native_build) { double('java build') }
  let(:build) { Jenkins::Model::Build.new(native_build) }
  let(:listener) { stub('listener') }

  let(:workspace) { tmpdir 'some-ws' }
  let(:artifacts_dir) { tmpdir 'build', 'X', 'archive' }

  subject { LockfileRecorder.new }

  before do
    native_build.stub!(:workspace).and_return(file_path workspace)
    native_build.stub!(:artifacts_dir).and_return(java_file artifacts_dir)
    native_build.stub!(:buildEnvironments).and_return(java.util.ArrayList.new)

    [:debug, :info, :warn, :error, :fatal, :unknown].each { |level| listener.stub!(level) }
  end

  def perform
    subject.perform(build, nil, listener)
  end

  describe 'when there is a lockfile' do
    let(:source) {
      [
        'GEM',
        '  remote: http://rubygems.org/',
        'specs:',
        '  rack (1.1.3)'
      ].join("\n")
    }

    before do
      (workspace + 'Gemfile.lock').open('w') { |f| f.write source }
    end

    it 'copies Gemfile.lock to a subdirectory of the artifacts directory' do
      perform

      (artifacts_dir + 'bundle-recorder' + 'Gemfile.lock').read.should == source
    end

    it 'notes what it is doing in the log' do
      listener.should_receive(:info).
        with("Recording bundle to #{artifacts_dir + 'bundle-recorder/Gemfile.lock'}.")

      perform
    end
  end

  describe 'when there is no lockfile' do
    it 'records an error' do
      listener.should_receive(:error).
        with("No bundle lock present to record. Was expecting #{workspace + 'Gemfile.lock'}.")

      perform
    end
  end
end
