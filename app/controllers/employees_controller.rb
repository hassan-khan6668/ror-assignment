require 'net/http'
require 'net/https'

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @employees = fetch_employees_from_api(params[:page])
  end

  def edit
    @employee = fetch_employee_from_api(params[:id])
  end

  def show
    @employee = fetch_employee_from_api(params[:id])
  end

  def create
    response = create_employee_via_api(employee_params)
    handle_response(response, :create)
  end

  def update
    response = update_employee_via_api(params[:id], employee_params)
    handle_response(response, :edit) 
  end

  private

  def handle_response(response, action)
    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"

    employee = JSON.parse(response.body)

    redirect_to action == :create ? employee_path(employee.dig("id")) : edit_employee_path(employee.dig("id"))
  end

  def employee_params
    {
      "name": params[:name],
      "position": params[:position],
      "date_of_birth": params[:date_of_birth],
      "salary": params[:salary]
    }
  end
end
