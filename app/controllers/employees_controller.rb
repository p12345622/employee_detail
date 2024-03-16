class EmployeesController < ApplicationController
	 before_action :set_employee, only: [:show, :update, :destroy]

  def create
    byebug
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def tax_deduction
    @employee = Employee.find(params[:id])
    tax_amount = calculate_tax(@employee.salary)
    cess_amount = calculate_cess(@employee.salary)
    render json: { 
      employee_code: @employee.id,
      first_name: @employee.first_name,
      last_name: @employee.last_name,
      yearly_salary: @employee.salary * 12,
      tax_amount: tax_amount,
      cess_amount: cess_amount
    }
  end

  private

  def employee_params
    params.require(:employee).permit( :first_name, :last_name, :email, :phone_numbers, :doj, :salary)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def calculate_tax(salary)
  	number_of_months = 12
    yearly_salary = salary * number_of_months
    if yearly_salary <= 250000
      return 0
    elsif yearly_salary <= 500000
      return (yearly_salary - 250000) * 0.05
    elsif yearly_salary <= 1000000
      return 12500 + (yearly_salary - 500000) * 0.10
    else
      return 62500 + (yearly_salary - 1000000) * 0.20
    end
  end

  def calculate_cess(salary)
  	number_of_months = 12
    yearly_salary = salary * number_of_months
    cess_amount = 0
    if yearly_salary > 2500000
      cess_amount = (yearly_salary - 2500000) * 0.02
    end
    cess_amount
  end
end
