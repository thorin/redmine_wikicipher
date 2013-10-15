#!/bin/env ruby
# encoding: utf-8
require 'redmine'

Redmine::Plugin.register :redmine_wikicipher do
  name 'Redmine Wikicipher plugin'
  author 'Sébastien Leroux'
  author_url 'mailto:sleroux@keep.pt'
  description 'This plugin adds the ability to encrypt section of text'
  version '0.0.8'
  url 'https://github.com/keeps/redmine_wikicipher'

  settings :default => HashWithIndifferentAccess.new(), :partial => 'settings/wikicipher_settings'
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'wikicipher/infectors'
  require_dependency 'wikicipher/redmine_ext'
end

require_dependency 'wikicipher/hooks'
require_dependency 'wikicipher/macros'