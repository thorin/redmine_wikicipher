require 'redmine'
# encoding: utf-8
module Wikicipher::Infectors::WikiController
  module InstanceMethods
    include Wikicipher::Encryption

    def show_with_wikicipher
      return show_without_wikicipher if @page.new_record? || !%w(pdf html txt).include?(params[:format])
      return show_without_wikicipher if params[:version] && !User.current.allowed_to?(:view_wiki_edits, @project)
      return show_without_wikicipher unless User.current.allowed_to?(:export_wiki_pages, @project)

      @content = WikiContent.new @page.content_for_version(params[:version]).attributes
      @content.text.gsub!(/\{{cipher\(1\)(.+?)}}/m) { "*#{decrypt $1.strip}*" }

      if params[:format] == 'pdf'
        @page = WikiPage.new @page.attributes
        @page.content = @content
        send_data(wiki_page_to_pdf(@page, @project), :type => 'application/pdf', :filename => "#{@page.title}.pdf")
        return
      elsif params[:format] == 'html'
        export = render_to_string :action => 'export', :layout => false
        send_data(export, :type => 'text/html', :filename => "#{@page.title}.html")
        return
      elsif params[:format] == 'txt'
        send_data(@content.text, :type => 'text/plain', :filename => "#{@page.title}.txt")
        return
      end

    end
  end
  def self.included(receiver) # :nodoc:
    receiver.send(:include, InstanceMethods)

    receiver.instance_eval do
      alias_method_chain :show, :wikicipher
    end
  end
end
