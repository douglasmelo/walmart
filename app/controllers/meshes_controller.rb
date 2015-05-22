class MeshesController < ApplicationController
  before_action :set_mesh, only: [:show, :edit, :update, :destroy]

  # GET /meshes
  # GET /meshes.json
  def index
    @meshes = Mesh.all
  end

  # GET /meshes/1
  # GET /meshes/1.json
  def show
  end

  # GET /meshes/new
  def new
    @mesh = Mesh.new
  end

  # GET /meshes/1/edit
  def edit
  end

  # Action
def search
   if valid_params
      #Search all meshes by origin
      meshes = Mesh.
       by_origin(params[:origin])
       .order(:origin)
       
       path_results = []
       distance_results = []

       #Possible path from origin
       meshes.each do |mash|
          distance = mash.distance
          logger.info "distance: #{mash.distance}"
          paths = []
          paths.push(params[:origin])
          find_next_destination(mash, paths, params[:destination], distance, path_results, distance_results)
       end

       autonomy = params[:autonomy]
       fuel_value = params[:fuel_value]

       @shortest_distance = distance_results[0]
       selected_index = 0
       for i in 1..distance_results.length-1
          if @shortest_distance > distance_results[i]
              @shortest_distance  = distance_results[i]
              selected_index = i
          end
       end 

       logger.info "shortest_distance: #{@shortest_distance}"
       @path = path_results[selected_index]
       logger.info "path: #{@path}"

       @cust = @shortest_distance.to_f / autonomy.to_f * fuel_value.to_f;
       logger.info "cuts: #{@cust}"

   else 
     not_acceptable
  end
end

  # POST /meshes
  # POST /meshes.json
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

  # PATCH/PUT /meshes/1
  # PATCH/PUT /meshes/1.json
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

  # DELETE /meshes/1
  # DELETE /meshes/1.json
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
      params.require(:mesh).permit(:origin, :destination, :map_name, :distance, :autonomy)
    end

    # validate the parameters
    def valid_params
     valid = true
     valid &= params.require(:origin)
     valid &= params.require(:destination)
     valid &= params.require(:autonomy)
     valid &= params.require(:fuel_value)
     valid
    end
  
    def find_next_destination(mash, paths, destination, distance, path_results, distance_results)
        if mash.destination != destination
          meshes = Mesh.
           by_origin(mash.destination)
           .order(:origin)

          paths.push(mash.destination)
          meshes.each do |mash|
              distance = distance + mash.distance
              find_next_destination(mash, paths, destination, distance, path_results, distance_results)
           end
        else
            paths.push(mash.destination)
            finalized_paths = Array.new(paths)
            path_results.push(finalized_paths)
            distance_results.push(distance)
            logger.info "path_results: #{path_results}"
            logger.info "distance_results: #{distance_results}"
        end
    end
end
