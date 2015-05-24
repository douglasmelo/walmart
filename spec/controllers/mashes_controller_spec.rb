require 'spec_helper'

describe MeshesController do
  render_views

  describe 'GET search' do
    it 'returns NOT_ACCEPTABLE status when params was invalid' do
      get :search, format: :json

      expect(response.status).to eq 406
    end

    it 'returns OK status when params was valid' do
      get :search, format: :json, origin: 'foo', destination: 'bar', autonomy: 'foo', fuel_value: 'bar'

      expect(response.status).to eq 200
    end

    it 'returns the lowest cost from A to D' do
      get :search, format: :json, origin: 'A', destination: 'D', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 6.25
      expect(parsed_response['path']).to eq ['A', 'B', 'D']

    end

    it 'returns the lowest cost from B to E' do
      get :search, format: :json, origin: 'B', destination: 'E', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 11.25
      expect(parsed_response['path']).to eq ['B', 'D', 'E']

    end

    it 'returns the lowest cost from A to E' do
      get :search, format: :json, origin: 'A', destination: 'E', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 13.75
      expect(parsed_response['path']).to eq ['A', 'B', 'D', 'E']

    end

    it 'returns the lowest cost from A to B' do
      get :search, format: :json, origin: 'A', destination: 'B', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 2.5
      expect(parsed_response['path']).to eq ['A', 'B']

    end

    it 'returns the lowest cost from A to C' do
      get :search, format: :json, origin: 'A', destination: 'C', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 5
      expect(parsed_response['path']).to eq ['A', 'C']

    end

    it 'returns no path from B to A' do
      get :search, format: :json, origin: 'B', destination: 'A', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 0
      expect(parsed_response['path']).to eq nil

    end

    it 'returns the lowest cost from B to D' do
      get :search, format: :json, origin: 'B', destination: 'D', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 3.75
      expect(parsed_response['path']).to eq ['B', 'D']

    end

    it 'returns the lowest cost from B to E' do
      get :search, format: :json, origin: 'B', destination: 'E', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 11.25
      expect(parsed_response['path']).to eq ['B', 'D', 'E']

    end

    it 'returns the lowest cost from C to D' do
      get :search, format: :json, origin: 'C', destination: 'D', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 7.5
      expect(parsed_response['path']).to eq ['C', 'D']

    end

    it 'returns the lowest cost from D to E' do
      get :search, format: :json, origin: 'D', destination: 'E', autonomy: 10, fuel_value: 2.5

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['cost']).to eq 7.5
      expect(parsed_response['path']).to eq ['D', 'E']

    end
  end
end