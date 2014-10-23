class PostsController < ApplicationController
  def index
    ######################
    ## ORDERING
    if params[:sort_by_clicks].present?
      if params[:sort_by_clicks] == '1'
        session[:sort_by_clicks] = true
      else
        session[:sort_by_clicks] = false
      end
    end

    session[:sort_by_clicks] = false if session[:sort_by_clicks].nil?
    @sort_by_clicks = session[:sort_by_clicks]
    ordering = (session[:sort_by_clicks] ? "clicks DESC, created_at DESC" : "created_at DESC")


    ######################
    ## SHOW HOTNESS
    if params[:show_hotness].present?
      if params[:show_hotness] == '1'
        session[:show_hotness] = true
      else
        session[:show_hotness] = false
      end
    end

    session[:show_hotness] = false if session[:show_hotness].nil?
    @show_hotness = session[:show_hotness]


    ######################
    ## SHOW INFO LINE
    if params[:show_info_line].present?
      if params[:show_info_line] == '1'
        session[:show_info_line] = true
      else
        session[:show_info_line] = false
      end
    end

    session[:show_info_line] = true if session[:show_info_line].nil?
    @show_info_line = session[:show_info_line]


    category = params[:category] || Category::APPLE
    @title = Category::CATEGORY_INFO[category][:title]
    @week = {}
    @week["Last 24 Hours"] = CategoryPost.includes(:post).where(category: category).where(created_at: (24.hours.ago..Time.now)).order(ordering)
    (1..6).each do |days_back|
      day = Date.current - days_back
      day_display = day.strftime("%A %B %-d, %Y")
      category_posts = CategoryPost.includes(:post).where(category: category).where(on_date: day).order(ordering)
      @week[day_display] = category_posts if category_posts.count > 0
    end
  end

  def url_redirect
    cp = CategoryPost.find(params[:cp_id])
    cp.increment_clicks(request.remote_ip)
    redirect_to cp.post.url
  end

  def vote_up
    cp = CategoryPost.find(params[:cp_id])
    cp.vote_up(request.remote_ip)
    redirect_to :root
  end

  def vote_down
    cp = CategoryPost.find(params[:cp_id])
    cp.vote_down(request.remote_ip)
    redirect_to :root
  end
end

