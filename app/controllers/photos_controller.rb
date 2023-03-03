class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    @list_of_comments = Comment.where({ :photo_id => the_id })


    @matching_likes = Like.where({ :photo_id => @the_photo.id })
    @array_of_fans = Array.new
    @matching_likes.each do |a_like|
      @array_of_fans.push(a_like.fan_id)
    end
    @list_of_fans = User.where({ :id => @array_of_fans })

    @current_user_fan = Like.where({ :photo_id => @the_photo.id }).where({ :fan_id => @current_user.id }).at(0)

    render({ :template => "photos/show.html.erb" })
  end

  def create
    current_user = User.where({ :id => session[:user_id] }).at(0) 

    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = 0
    the_photo.image = params.fetch("query_image")
    the_photo.likes_count = 0
    the_photo.owner_id = current_user.id

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.comments_count = params.fetch("query_comments_count")
    the_photo.image = params.fetch("query_image")
    the_photo.likes_count = params.fetch("query_likes_count")
    the_photo.owner_id = params.fetch("query_owner_id")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
