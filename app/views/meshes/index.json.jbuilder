json.array!(@meshes) do |mesh|
  json.extract! mesh, :id, :origin, :destination, :map_name, :distance
  json.url mesh_url(mesh, format: :json)
end
