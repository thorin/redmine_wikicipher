# encoding: utf-8
module RedmineWikicipher
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
        if context[:controller].is_a? WikiController
            stylesheet_link_tag 'redmine_wikicipher.css', :plugin => 'redmine_wikicipher'
        end
    end

    def view_layouts_base_body_bottom(context={})
        if context[:controller].is_a? WikiController && !context[:project].nil?
            javascript_include_tag cipher_javascript_path(:project_id => context[:project])
        end
    end
  end
end
