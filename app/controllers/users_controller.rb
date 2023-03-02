class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :username => the_id })

    @the_user = matching_users.at(0)

    @followers_count = FollowRequest.where({ :status => "accepted" }).where({ :recipient => @the_user.id }).count

    @following_count = FollowRequest.where({ :status => "accepted" }).where({ :sender => @the_user.id }).count

    @list_of_photos = Photo.where({:owner => @the_user.id})

    render({ :template => "users/show.html.erb" })
  end

  def show_likes
    the_id = params.fetch("path_id")
    matching_users = User.where({ :username => the_id })

    @the_user = matching_users.at(0)

    @followers_count = FollowRequest.where({ :status => "accepted" }).where({ :recipient => @the_user.id }).count

    @following_count = FollowRequest.where({ :status => "accepted" }).where({ :sender => @the_user.id }).count
    
    @matching_likes = Like.where({ :fan_id => @the_user })
    @array_of_photo_ids = Array.new
    @matching_likes.each do |a_like|
      the_photo_like = a_like.photo
      @array_of_photo_ids.push(the_photo_like.id)
    end
    @list_of_photos_liked = Photo.where({ :id => @array_of_photo_ids })


    render({ :template => "users/show_likes.html.erb" })
  end


end
