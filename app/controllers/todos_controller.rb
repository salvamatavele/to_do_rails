class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[index show]
  before_action :correct_user, only: %i[edit update destroy]
  # GET /todos or /todos.json
  def index
    @todos = Todo.all
    @title = 'Todos'
  end

  # GET /todos/1 or /todos/1.json
  def show
    @title = @todo.title
  end

  # GET /todos/new
  def new
    #@todo = Todo.new
    @todo = current_user.todo.build
    @title = 'New Todo'
  end

  # GET /todos/1/edit
  def edit
    @title = @todo.title
  end

  # POST /todos or /todos.json
  def create
    #@todo = Todo.new(todo_params)
    @todo = current_user.todo.build(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @todo = current_user.todo.find_by(id: params[:id])
    redirect_to todos_path, notice: "Not authorized to edit this todo" if @todo.nil?
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:user_id, :title, :content, :due, :done)
    end
end
