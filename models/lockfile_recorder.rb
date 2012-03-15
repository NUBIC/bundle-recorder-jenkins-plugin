class LockfileRecorder < Jenkins::Tasks::Publisher
  display_name "Archive bundler Gemfile.lock"

  def perform(build, launcher, listener)
    lockfile = built_lockfile(build)

    if lockfile.exists()
      archive_target = archive_dir(build).child('Gemfile.lock')
      listener.info("Recording bundle to #{archive_target}.")
      lockfile.copyTo(archive_target)
    else
      listener.error("No bundle lock present to record. Was expecting #{lockfile}.")
    end
  end

  def archive_dir(build)
    Java.hudson.FilePath.new(build.native.artifacts_dir).child('bundle-recorder')
  end
  private :archive_dir

  def built_lockfile(build)
    # TODO: allow this to be configured
    build.native.workspace.child('Gemfile.lock')
  end
end
