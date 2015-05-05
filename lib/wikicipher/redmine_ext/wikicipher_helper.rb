module Redmine::WikiFormatting::Textile::Helper
  def heads_for_wiki_formatter_with_wikicipher
    heads_for_wiki_formatter_without_wikicipher

    unless @heads_for_wiki_formatter_with_wikicipher_included || controller_name != 'wiki'
      lang = current_language.to_s.downcase
      lang = 'en' unless %w(de en pt ru).include? lang
      content_for :header_tags do
        javascript_include_tag('jstoolbar/wikicipher.js', :plugin => 'redmine_wikicipher') +
        javascript_include_tag("jstoolbar/lang/wikicipher-#{lang}.js", :plugin => 'redmine_wikicipher') +
        stylesheet_link_tag('jstoolbar_wikicipher.css', :plugin => 'redmine_wikicipher')
      end
    end
    @heads_for_wiki_formatter_with_wikicipher_included = true
  end

  alias_method_chain :heads_for_wiki_formatter, :wikicipher
end
