require_dependency 'projects_controller'

module RedmineJenkins
  module Patches
    module ProjectsControllerPatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          helper :jenkins
          helper :redmine_bootstrap_kit

          alias_method :settings_without_redmine_jenkins, :settings
          alias_method :settings, :settings_with_redmine_jenkins
        end
      end


      module InstanceMethods

        def settings_with_redmine_jenkins(&block)
          settings_without_redmine_jenkins(&block)
          if @project.jenkins_setting.nil?
            @jenkins_setting = JenkinsSetting.new
            @jobs = []
          else
            @jenkins_setting = @project.jenkins_setting
            @jobs = @project.jenkins_jobs
          end
        end

      end

    end
  end
end

unless ProjectsController.included_modules.include?(RedmineJenkins::Patches::ProjectsControllerPatch)
  ProjectsController.send(:include, RedmineJenkins::Patches::ProjectsControllerPatch)
end
