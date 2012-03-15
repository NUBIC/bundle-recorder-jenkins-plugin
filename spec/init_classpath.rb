require 'java'
require 'pathname'
require 'fileutils'

# see spec_helper in jenkins-plugin-runtime
module Jenkins
  def self.rspec_ewwww_gross_hack?
    true
  end
end

module BundleRecorder
  module Spec
    module Classpath
      extend FileUtils::Verbose

      module_function

      def plugin_spec
        @plugin_spec ||= eval(File.read(
            File.expand_path '../../bundle-recorder.pluginspec', __FILE__))
      end

      def exploded_plugins_path
        @exploded_plugins_path ||=
          Pathname.new(File.expand_path('../../exploded_dependencies', __FILE__))
      end
      private :exploded_plugins_path

      def exploded_plugin_path(name, version)
        exploded_plugins_path + name + version
      end

      def explode_plugin(name, version)
        target_path = exploded_plugin_path(name, version)
        unless target_path.exist?
          hpi_path = Pathname.new(File.join(
              ENV['HOME'], '.jenkins', 'cache', 'plugins', name, version, "#{name}.hpi"))
          unless hpi_path.exist?
            fail "Cached HPI for #{name} (#{version}) not found. " +
              "Try running `jpi server` to get it downloaded.\n(Looked for #{hpi_path}.)"
          end

          target_path.mkpath
          cd target_path.to_s do
            cmd = "unzip -q '#{hpi_path}'"
            $stderr.puts cmd
            system(cmd)
          end
        end
        target_path
      end
      private :explode_plugin

      def init
        plugin_spec.dependencies.each do |name, version|
          exploded_dir = explode_plugin(name, version)

          Dir[exploded_dir + "**/*.jar"].each do |jar|
            $CLASSPATH << jar
          end
          $CLASSPATH << (exploded_dir + 'WEB-INF/classes')
        end

        require 'jenkins/war'
        Jenkins::War.classpath # side effect is exploding the war
        for path in Dir[File.join(ENV['HOME'], '.jenkins', 'wars', Jenkins::War::VERSION, "**/*.jar")]
          $CLASSPATH << path
        end

        require 'jenkins/plugin/runtime'
      end
    end
  end
end
