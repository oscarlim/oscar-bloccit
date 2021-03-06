class TopicsController < ApplicationController
  def index
    @topics = Topic.visible_to(current_user).paginate(page: params[:page], per_page: 10)
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "you need to be an admin to do that"
  end

  def show
    @topic = Topic.find(params[:id])
    authorize! :read, @topic, message: "You need to be signed-in to do that."
    @posts = @topic.posts.includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "you need to be an admin to do that."
  end

  # Adding a create method to the topics_controller.rb
  def create
    @topic = Topic.new(params[:topic])
    authorize! :create, @topic, message: "you need to be an admin to do that."
    if @topic.save
      redirect_to @topic   #bloc answer is to use ,notice: "Topic was saved successfully."
      flash[:notice] = "Topic was saved"
    else
      flash[:error] = "There was an error saving the topic. Please try again"
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:id]) #make sure to use .find for update function
    authorize! :update, @topic, message: "you need to own the topic to update it."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic
      flash[:notice] = "Topic was updated."
    else
      flash[:error] = "There was an error updating the topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    name = @topic.name
    authorize! :destroy, @topic, message: "You need to own the topic to delete it."
    if @topic.destroy
      flash[:notice] = "\"#{name}\" was deleted successfully."
      redirect_to topics_path
    else
      flash[:error] = "There was an error deleting the topic."
      render :show
    end
  end
end

