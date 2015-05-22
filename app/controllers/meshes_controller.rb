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
      @meshes = Mesh.
       by_origin(params[:origin])
       .order(:origin)
       
       path_results = Array.new
       distance_results = Array.new

       #Possible path from origin
       @meshes.each do |mash|
          distance = mash.distance
          puts "distance: #{mash.distance}"
          caminhos = Array.new
          caminhos.push(params[:origin])
          findNextDestination(mash, caminhos, params[:destination], distance, path_results, distance_results)
       end

       autonomy = params[:autonomy]
       fuel_value = params[:fuel_value]

       shortest_distance = distance_results[0]
       selected_index = 0
       for i in 1..distance_results.length-1
          if(shortest_distance > distance_results[i])
              shortest_distance  = distance_results[i]
              selected_index = i
          end
       end 

       puts "shortest_distance: #{shortest_distance}"
       puts "shortest_path: #{path_results[selected_index]}"

       cust = shortest_distance.to_f/autonomy.to_f * fuel_value.to_f;
       puts "cuts: #{cust}"

       render action: 'index'
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

    def valid_params
      #validate the parameters
      valid = true
      if(!params.require(:origin))
        valid = false
      end
      if(!params.require(:destination))
        valid = false
      end
      if(!params.require(:autonomy))
        valid = false
      end
      if(!params.require(:fuel_value))
        valid = false
      end
      valid
    end

    def findNextDestination(mash, caminhos, destination, distance, path_results, distance_results)
        if(mash.destination != destination)
          @meshes = Mesh.
           by_origin(mash.destination)
           .order(:origin)

          caminhos.push(mash.destination)
          @meshes.each do |mash|
              distance = distance + mash.distance
              findNextDestination(mash, caminhos, destination, distance, path_results, distance_results)
           end
        else
            caminhos.push(mash.destination)
            # puts "**** caminho encontrado *****"
            caminhos_finalizado = Array.new(caminhos)
            path_results.push(caminhos_finalizado)
            distance_results.push(distance)
            puts "path_results: #{path_results}"
            puts "distance_results: #{distance_results}"
        end
    end
end
