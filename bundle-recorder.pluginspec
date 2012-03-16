require 'jenkins/plugin/specification'

Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "bundle-recorder"
  plugin.display_name = "Gem Bundle Recorder Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'Records the gems bundled by your ruby project at each run. Can show differences between runs to assist debugging.'

  # You should create a wiki-page for your plugin when you publish it, see
  # https://wiki.jenkins-ci.org/display/JENKINS/Hosting+Plugins#HostingPlugins-AddingaWikipage
  # This line makes sure it's listed in your POM.
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/My+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "rsutphin", "Rhett Sutphin <rhett@detailedbalance.net>"

  # This specifies where your code is hosted.
  # Alternatives include:
  #  :github => 'myuser/my-plugin' (without myuser it defaults to jenkinsci)
  #  :git => 'git://repo.or.cz/my-plugin.git'
  #  :svn => 'https://svn.jenkins-ci.org/trunk/hudson/plugins/my-plugin'
  plugin.uses_repository :github => 'NUBIC/jenkins-bundle-recorder'

  # This is a required dependency for every ruby plugin.
  plugin.depends_on 'ruby-runtime', '0.9'
end
