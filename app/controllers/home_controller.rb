class HomeController < ApplicationController
  def index
    if session.empty? || !session['user']
      redirect_to url_for({ :controller => 'consumer', :action => 'index'}) and return
    end

    # Login successed 
    user = session['user']
    flash[:user_display_name] = user[:identifier]
    puts user
  end

  def logout
    session['user'] = nil
    redirect_to url_for({ :controller => 'consumer', :action => 'index'})
  end

end
