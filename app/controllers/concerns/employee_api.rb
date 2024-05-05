# app/controllers/concerns/employee_api.rb
module EmployeeApi
  extend ActiveSupport::Concern

  def fetch_employees_from_api(page = nil)
    uri = build_uri("employees", page)
    send_request(uri)
  end

  def fetch_employee_from_api(id)
    uri = build_uri("employees/#{id}")
    send_request(uri)
  end

  def create_employee_via_api(params)
    uri = build_uri("employees")
    send_http_request(uri, Net::HTTP::Post, params)
  end

  def update_employee_via_api(id, params)
    uri = build_uri("employees/#{id}")
    send_http_request(uri, Net::HTTP::Put, params)
  end

  def delete_employee_via_api(id)
    uri = build_uri("employees/#{id}")
    send_http_request(uri, Net::HTTP::Delete)
  end

  private

  def build_uri(path, page = nil)
    uri = URI("https://dummy-employees-api-8bad748cda19.herokuapp.com/#{path}")
    uri.query = "page=#{page}" if page.present?
    uri
  end

  def send_request(uri)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def send_http_request(uri, request_type, params = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = request_type.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = params.to_json if params

    http.request(request)
  end
end
