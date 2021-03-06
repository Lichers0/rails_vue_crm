class Staffs::OrganizationsController < ApplicationController
  before_action :authenticate_staff!
  before_action :find_organization, only: [:update, :destroy]

  def index
    organizations = FindOrganizations.new(Organization.all)
                                     .call(params)
                                     .page(params[:page])
                                     .per(params[:per_page])

    render json: organizations, each_serializer: OrganizationFullSerializer,
           meta: {rows_number:organizations.total_count, page: organizations.current_page}

  end

  def create
    organization = Organization.new(organization_params)

    if organization.save
      render json: organization, serializer: OrganizationSerializer, status: :created
    else
      render json: { errors: organization.errors }, status: :unprocessable_entity
    end
  end

  def update
    clients_ids = params[:clients].pluck(:id)
    equipment_ids = params[:equipment].pluck(:id)

    if @organization.update(organization_params)
      @organization.client_ids = clients_ids
      @organization.equipment_ids = equipment_ids
      render json: @organization, serializer: OrganizationSerializer, status: :ok
    else
      render json: { errors: @organization.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
  end

  def validate_uniqueness
    name = Organization.find_by(name: params[:name])
    inn = Organization.find_by(inn: params[:inn])

    if name && inn
      render json: { uniqueness: { organization_name: "Organization #{params[:name]} already exists",
                                   inn: "Organization with INN: #{params[:inn]} already exists" }}
    elsif name
      render json: { uniqueness: { organization_name: "Organization #{params[:name]} already exists" }}
    elsif inn
      render json: { uniqueness: { inn: "Organization with INN: #{params[:inn]} already exists" }}
    else
      render json: { uniqueness: {} }
    end
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :structure, :inn, :ogrn)
  end
end
