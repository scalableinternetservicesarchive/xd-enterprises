class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save

      #flash[:success] = "Micropost created!"

      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    #flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  def show
    @user = User.find_by_id(params[:id])
    if stale?([Commontator::Thread.find(params[:id]), Micropost.find_by_id(params[:id])])
      @post = Micropost.find_by_id(params[:id])
      if !@post.nil?
        commontator_thread_show(@post)
      else
        redirect_to root_url
      end
      #p "NOT CACHEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"
    #else
      #p "THIS IS HELLA CACHED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    end
  
    # handle any errors from the code above
    # @mpost = Micropost.all
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end