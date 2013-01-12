class UsersController < ApiController

  def create
  	@user = User.new(params[:user])

    if @user.save
      render :json=>{:success => true, :message=>"success to create user."}
      return
    else
      render :json=>{:success => false, :message=>"fail to create user."}
      return  		
    end
  end

  def getUserInfo

  	@imei = params[:imei]
  	@user = User.getUserInfo(@imei)

  	if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to get user."}
  	else
      metadata = {:success => true, :message=>"success to get user."}
      respond_with(@user, :api_template => :render_users, :root => :users, :meta => metadata)
  	end
  end

  def checkUniqueness
    @nickname = params[:nickname]
    if (User.uniqueNickname?(@nickname))
      render :json=>{:success => true, :message=>"fail to get user.", :occupied=>false}
    else
      render :json=>{:success => true, :message=>"fail to get user.", :occupied=>true}
    end
  end

  def alertUser
    @imei = params[:imei]
    @user = User.getUserInfo(@imei)
    if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to alert user. no user found"}
      return      
    end

    alert_count = @user.alert_count + 1

    if (@user.update_attributes(:alert_count => alert_count))
      render :json=>{:success => true, :message=>"success to alert user."}
      return
    else
      render :json=>{:success => false, :message=>"fail to alert user."}
      return      
    end
  end

  def getHighAlertUsers
    @users = User.getHighAlertUsers
    
    if (@users.nil? or @users.count == 0)
      render :json=>{:success => false, :message=>"fail to get hight alert user list"}
      return  
    else
      metadata = {:success => true, :message=>"success to get high alert user list."}
      respond_with(@users, :api_template => :render_users, :root => :users, :meta => metadata) 
    end
  end

  def blockUser
    @imei = params[:imei]
    @user = User.getUserInfo(@imei)

    if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to block user. no user found"}
      return      
    end

    if (@user.update_attributes(:blocked => true))
      render :json=>{:success => true, :message=>"success to block user."}
      return
    else
      render :json=>{:success => false, :message=>"fail to block user."}
      return      
    end
  end

  def unBlockUser
    @imei = params[:imei]
    @user = User.getUserInfo(@imei)

    if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to unblock user. no user found"}
      return      
    end

    if (@user.update_attributes(:blocked => false))
      render :json=>{:success => true, :message=>"success to unblock user."}
      return
    else
      render :json=>{:success => false, :message=>"fail to unblock user."}
      return      
    end
  end

  def getBlockedUserList
    @users = User.getBlockedUsers
    
    if (@users.nil? or @users.count == 0)
      render :json=>{:success => false, :message=>"fail to get blocked user list"}
      return  
    else
      metadata = {:success => true, :message=>"success to get blocked user list."}
      respond_with(@users, :api_template => :render_users, :root => :users, :meta => metadata) 
    end
  end

end
