class BundledGems
  include Jenkins::Model::Action

  display_name 'Bundled Gems'
  url_path 'bundled_gems'
  icon 'fingerprint.png'

  attr_accessor :archived_lockfile

  def initialize(archived_lockfile)
    super()

    @archived_lockfile = archived_lockfile.to_s
  end
end

class BundledGemsProxy
  include Jenkins::Plugin::Proxies::Action

  proxy_for BundledGems
end
