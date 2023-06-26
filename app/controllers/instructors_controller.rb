class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index 
    instructors = Instructor.all 
    render json: instructors, status: :ok, only: [:name, :id]
  end

  def show 
    instructor = finder 
    render json: instructor, except: [:created_at, :updated_at], include: { students: { except: [:created_at, :updated_at] } }, status: :ok
  end

  def create 
    new_instructor = Instructor.create!(instructor_params)
    render json: new_instructor, status: :created    
  end 

  def update 
    instructor = finder 
    instructor.update!(instructor_params)
    render json: instructor
  end

  def destroy 
    instructor = finder 
    instructor.destroy 
    head :no_content
  end

  private

  def render_not_found_response
    render json: { error: "Instructor Not Found" }, status: :not_found
  end

  def render_unprocessable_entity(invalid)
    render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end 

  def instructor_params 
    params.permit(:name, :id)
  end

  def finder 
    instructor = Instructor.find(params[:id])
  end
end
