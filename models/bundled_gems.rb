# For some reason, the ruby API is a) forcing this Action to be used
# as a Rack handler and b) not loading rack before jruby-rack. This is
# enough of rack to get it to render.
module Rack
  VERSION = [1, 1]

  def self.release
    "1.3"
  end
end

class BundledGems
  include Jenkins::Model::Action

  display_name 'Bundle Gem Changes'
  url_path 'bundledGems'
  icon 'fingerprint.png'

  attr_reader :archived_lockfile
  attr_reader :previous_lockfile

  def initialize(archived_lockfile, previous_lockfile=nil)
    super()

    @archived_lockfile = archived_lockfile
    @previous_lockfile = previous_lockfile
  end

  def call(env)
    [200, { 'Content-Type' => 'text/html' }, body]
  end

  def body
    if previous_lockfile
      differences = `diff '#{previous_lockfile}' '#{archived_lockfile}'`.strip
      if differences.empty?
        [
          "No differences"
        ]
      else
        [
          `colordiff -u '#{previous_lockfile}' '#{archived_lockfile}' | ansifilter -H`
        ]
      end
    else
      [
        'No previous gems'
      ]
    end
  end
end

class BundledGemsProxy
  include Jenkins::Plugin::Proxies::Action

  proxy_for BundledGems
end
