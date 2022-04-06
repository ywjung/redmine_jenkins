require_dependency 'projects_helper'

module RedmineJenkins
  module ProjectSettingsTabs
    def self.apply
      ProjectsController.send :helper, RedmineJenkins::ProjectSettingsTabs
    end

    def project_settings_tabs
      tabs = super
      if User.current.allowed_to?(:edit_jenkins_settings, @project)
        tabs.push({
          name: 'jenkins',
          action: :edit_jenkins_settings, 
          partial: 'projects/settings/redmine_jenkins', 
          label: :label_jenkins
        })
      end
      tabs
    end

  end
end
 
