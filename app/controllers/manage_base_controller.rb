class ManageBaseController < ApplicationController
  # before_action :store_referer, only: [:new, :edit, :destroy, :switch]

  # protected
  # def referer_or(url)
  #   session.delete(:referer).presence || url
  # end

  # private
  # def store_referer
  #   session[:referer] = request.referer if request.referer.present? && session[:skip_referer].blank?
  #   session.delete(:skip_referer) if session[:skip_referer]
  # end
end

