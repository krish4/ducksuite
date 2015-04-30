class API::BaseController < ApplicationController
  before_filter :check_access

  private
  def check_access
    return if granted_access?
    render json: { code: '403', message: 'You are not allowed to access this endpoint.' }, status: 403
  end

  def granted_access?
    whitelisted? || Domain.allows?(domain)
    end

  def whitelisted?
    ENV['WHITELISTED_DOMAINS'].present? && ENV['WHITELISTED_DOMAINS'].include?(domain)
  end

  def domain
    @domain ||= URI.parse(request_url).host
  end

  def request_url
    headers['Access-Control-Allow-Origin']  = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age']       = "1728000"
    request.referer.present? ? request.referer : request.original_url
  end

  def default_serializer_options  
    { root: false }  
  end  
end
