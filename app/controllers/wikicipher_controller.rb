class WikicipherController < ApplicationController
  include Wikicipher::Encryption

  def decode
    respond_to do |format|
      format.json do
        values = params[:values] || []
        render :json => values.map {|v| decrypt(v) rescue l("wikicipher.bad_decrypt") }
      end
    end
  end

  def javascript
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.js { render }
    end
  end

  def api_request?; false; end
end