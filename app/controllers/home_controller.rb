class HomeController < ApplicationController
  def index
    puts '-' * 60
    if !session['user'] || session['user'].empty?
      redirect_to url_for({ :controller => 'consumer', :action => 'index'})
    end
    user = session['user']
    flash[:user_display_name] = user[:identifier]
    puts user
  end

  def logout
    session['user'] = {}
    redirect_to url_for({ :controller => 'consumer', :action => 'index'})
  end

end
