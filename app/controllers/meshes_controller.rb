class MeshesController < ApplicationController
  before_action :set_mesh, only: [:show, :edit, :update, :destroy]

  def index
    @meshes = Mesh.all
  end

  def show
  end

  def new
    @mesh = Mesh.new
  end

  def edit
  end

  def search
    if valid_params
      results = {}

      Mesh.by_origin(params[:origin]).each do |mash|
        origins = [params[:origin]]
        find_next_destination(mash, origins, params[:destination], mash.distance, results)
      end

      minimum = results.keys.min
      @path = results[minimum]
      @cust = minimum.to_f / params[:autonomy].to_f * params[:fuel_value].to_f
    else
      respond_to do |format|
        format.html { render file: File.join(Rails.root, 'public', '406'), status: :not_acceptable }
        format.json { render text: '{"error": "not_acceptable"}', status: :not_acceptable }
      end
    end
  end

  def create
    @mesh = Mesh.new(mesh_params)

    respond_to do |format|
      if @mesh.save
        format.html { redirect_to @mesh, notice: 'Mesh was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mesh }
      else
        format.html { render action: 'new' }
        format.json { render json: @mesh.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @mesh.update(mesh_params)
        format.html { redirect_to @mesh, notice: 'Mesh was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mesh.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mesh.destroy
    respond_to do |format|
      format.html { redirect_to meshes_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_mesh
    @mesh = Mesh.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mesh_params
    params.require(:mesh).permit(:origin, :destination, :map_name, :distance)
  end

  # validate the parameters
  def valid_params
    params[:origin].present? &&
      params[:destination].present? &&
      params[:autonomy].present? &&
      params[:fuel_value].present?
  end

  def find_next_destination(reference_mash, paths, destination, distance, results)
    paths << reference_mash.destination

    if reference_mash.destination != destination
      Mesh.by_origin(reference_mash.destination).each do |mash|
        distance += mash.distance
        find_next_destination(mash, paths, destination, distance, results)
      end
    else
      results[distance] = paths.clone
    end
  end
end
