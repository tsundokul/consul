class PagesController < ApplicationController
  include FeatureFlags
  skip_authorization_check

  feature_flag :help_page, if: lambda { params[:id] == "help/index" }

  def show
    @custom_page = SiteCustomization::Page.published.find_by(slug: params[:id])

    if @custom_page.present?
      @title_bgcolor = custom_page_attr('bgcolor')
      @title_color = custom_page_attr('color')
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
      'custom_pages',
      @custom_page.slug,
      attr
    )
  end

end
