class Mesh < ActiveRecord::Base
  scope :by_origin, ->(origin = nil) { where(origin: origin) if origin.present? }
  scope :by_destination, ->(destination = nil) { where(destination: destination) if destination.present? }

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