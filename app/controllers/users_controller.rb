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

  def show_feed
    the_id = params.fetch("path_id")

    matching_users = User.where({ :username => the_id })

    @the_user = matching_users.at(0)

    @followers_count = FollowRequest.where({ :status => "accepted" }).where({ :recipient => @the_user.id }).count

    @following_count = FollowRequest.where({ :status => "accepted" }).where({ :sender => @the_user.id }).count

    array_of_photo_ids = Array.new

    my_follow_requests = FollowRequest.where({ :sender_id => @the_user.id }).where({:status => "accepted"})

    my_follow_requests.each do |a_follow_request|
      matching_photos = Photo.where({ :owner_id => a_follow_request.recipient_id })
      matching_photos.each do |a_matching_photo|
        array_of_photo_ids.push(a_matching_photo.id)
      end
    end

    @list_of_photos_following  = Photo.where({ :id => array_of_photo_ids })

    render({ :template => "users/show_feed.html.erb" })
  end

  def show_discover
    the_id = params.fetch("path_id")

    matching_users = User.where({ :username => the_id })

    @the_user = matching_users.at(0)

    @followers_count = FollowRequest.where({ :status => "accepted" }).where({ :recipient => @the_user.id }).count

    @following_count = FollowRequest.where({ :status => "accepted" }).where({ :sender => @the_user.id }).count

    array_of_photo_ids = Array.new

    my_follow_requests = FollowRequest.where({ :sender_id => @the_user.id }).where({:status => "accepted"})

    my_follow_requests.each do |a_follow_request|
      following_likes = Like.where({ :fan_id => a_follow_request.recipient_id })
      following_likes.each do |a_like|
        a_matching_photo = Photo.where({ :id => a_like.photo_id }).at(0)
        array_of_photo_ids.push(a_matching_photo.id)
      end
    end

    @list_of_photos_following  = Photo.where({ :id => array_of_photo_ids })

    render({ :template => "users/show_discover.html.erb" })
  end

  def not_authorized
    redirect_to("/", { :notice => "You're not authorized for that."})
  end


end
