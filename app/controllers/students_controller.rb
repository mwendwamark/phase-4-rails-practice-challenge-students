class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index
    students = Student.all
    render json: students, except: [:created_at, :updated_at], status: :ok
  end

  def show
    student = finder
    render json: student, except: [:created_at, :updated_at], include: { instructor: { except: [:created_at, :updated_at] } }, status: :ok
  end

  def create
    new_student = Student.create!(student_params)
    render json: new_student, include: :instructor, status: :created
  end

  def update 
    instructor = finder 
    instructor.update!(student_params)
    render json: instructor, status: :accepted
  end

  def destroy
    student = finder
    student.destroy
    head :no_content
  end

  private

  def render_not_found_response
    render json: { error: "Student Not Found" }, status: :not_found
  end

  def render_unprocessable_entity(invalid)
    render json: { errors: invalid.record.errors.full_messages }
  end

  def finder
    student = Student.find(params[:id])
  end

  def student_params
    params.permit(:name, :age, :instructor_id, :major)
  end
end
