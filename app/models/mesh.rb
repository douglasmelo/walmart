class Mesh < ActiveRecord::Base
  scope :by_origin, ->(origin = nil) { where(origin: origin) if origin.present? }
  scope :by_destination, ->(destination = nil) { where(destination: destination) if destination.present? }
end