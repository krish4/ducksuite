class API::DomainsController < API::BaseController
  before_filter :set_domain, [:destroy]

  def create
    domain = Domain.create(domain_params)
    render json: domain
  end

  def destroy
    @domain.destroy if @domain.present?
    head :no_content
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :user_id)
  end

  def set_domain
    @domain = Domain.find_by(id: params[:id])
  end
end
