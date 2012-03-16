class LockfileRecorder < Jenkins::Tasks::Publisher
  display_name "Archive bundler Gemfile.lock"

  def perform(build, launcher, listener)
    lockfile = built_lockfile(build)

    if lockfile.exists()
      archive_target = archive_dir(build).child('Gemfile.lock')
      listener.info("Recording bundle to #{archive_target}.")
      lockfile.copyTo(archive_target)

      previous_lockfile =
        if build.native.previous_build
          previous_gems = build.native.
            previous_build.actions.find { |a| a.class.to_s =~ /BundledGemsProxy/ }
          if previous_gems
            previous_gems.getTarget.archived_lockfile
          end
        end

      build.native.add_action(export(
          BundledGems.new(archive_target, previous_lockfile)
          ))
    else
      listener.error("No bundle lock present to record. Was expecting #{lockfile}.")
      build.native.result = Java.hudson.model.Result::FAILURE
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
  private :built_lockfile

  def export(a)
    Jenkins.plugin.export(a)
  end
  private :export
end
