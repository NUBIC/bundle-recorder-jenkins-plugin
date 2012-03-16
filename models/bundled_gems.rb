class BundledGems
  include Java.hudson.model.Action
  include Jenkins::Model

  display_name 'Bundled Gems'

  def url_name
    'bundledGems'
  end

  def icon_file_name
    'fingerprint.png'
  end

  attr_accessor :archived_lockfile

  def initialize(archived_lockfile)
    super()

    @archived_lockfile = archived_lockfile.to_s
  end
end

# TODO: this isn't being used, I don't think (at least, there's
# behavior difference whether it is present or not). It was added as a
# stab at fixing the serialization problem. I'm leaving it here as a
# reminder until I figure out an actual solution.
class BundledGemsProxy
  include Jenkins::Plugin::Proxy
  # include Jenkins::Plugin::Proxies::Action

  proxy_for BundledGems
end
