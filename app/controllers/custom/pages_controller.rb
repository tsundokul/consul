class PagesController < ApplicationController
  include FeatureFlags
  skip_authorization_check

  feature_flag :help_page, if: lambda { params[:id] == "help/index" }

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    if @custom_page.present?
      @title_icon = custom_page_attr('icon')
      @title_bgcolor = custom_page_attr('bgcolor')
      @cards = @custom_page.cards
      render action: :custom_page
    else
      render action: params[:id]
    end
  rescue ActionView::MissingTemplate
    head 404, content_type: "text/html"
  end

  private

  def custom_page_attr(attr)
    Rails.configuration.deploy.dig(
      'custom_page',
      @custom_page.slug,
      attr
    )
  end

end
