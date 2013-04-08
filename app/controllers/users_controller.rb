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

  def update
    @user = User.getUserInfo(params[:imei])
    @profile = params[:profile]
    @intro = params[:intro]
    
    if (@profile.nil?)
      @user.update_attributes(:intro => @intro) 
    else
      @user.update_attributes(:profile => @profile, :intro => @intro) 
    end

    if (@user.save)
      render :json=>{:profile_thumbnail_path => @user.profile_thumbnail_path, :success => true, :result_code => 0, :message=>"success to update user."}
    else
      render :json=>{:success => false, :result_code => 2, :message=>"fail to update user."}
    end
  end

  def destroy
    @user = User.getUserInfo(params[:imei])
    if @user.destroy
      render :json=>{:success => true, :message=>"success to destroy user."}
      return
    else
      render :json=>{:success => false, :message=>"fail to destroy user."}
      return      
    end
  end

  def getUserList
    @users = User.all
    if (@users.nil?)
      render :json=>{:success => false, :message=>"fail to get users."}
    else
      metadata = {:success => true, :message=>"success to get users."}
      respond_with(@users, :api_template => :render_users, :root => :users, :meta => metadata)
    end
  end

  def getUserInfo

  	@imei = params[:imei]
  	@user = User.getUserInfo(@imei)

  	if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to get user."}
  	else
      metadata = {:success => true, :message=>"success to get user."}
      respond_with(@user, :api_template => :render_users, :root => :user, :meta => metadata)
  	end
  end

  def getUserInfoByNickname

    @nickname = params[:nickname]
    @user = User.getUserInfoByNickname(@nickname)

    if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to get user."}
    else
      metadata = {:success => true, :message=>"success to get user."}
      respond_with(@user, :api_template => :render_users, :root => :user, :meta => metadata)
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

  def alertUserV2
    @imei = params[:imei]
    @nickname = params[:nickname]
    @me = User.getUserInfo(@imei)
    @alert_user = User.getUserInfoByNickname(@nickname)

    if (@me.nil?)
      render :json=>{:success => false, :message=>"fail to alert user. no me found"}
      return      
    end

    if (@alert_user.nil?)
      render :json=>{:success => false, :message=>"fail to alert user. no alert target user found"}
      return      
    end

    if (@me.has_alerted?@alert_user)
      render :json=>{:success => false, :result_code => 1, :message=>"already alert user"}
      return
    end

    if (@me.alert!(@alert_user))
      render :json=>{:success => true, :result_code => 0, :message=>"success to update alert count. current alert"}
    else
      render :json=>{:success => false, :result_code => 2, :message=>"fail to update alert count."}
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
  def getHighAlertUsersV2
    @users = User.page(params[:page]).order('alerters_count DESC').limit(100)

  #   @users = User.getHighAlertUsersV2

    #@users = User.find(:all, :include => Authors, :group_by => " SELECT `count` as (some subquery I don't know to get the number of followers)", :limit => 10)

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

  def updateNickname
    @imei = params[:imei]
    @new_nick_name = params[:nickname]

    @user = User.getUserInfo(@imei)
    
    if (@user.nil?)
      render :json=>{:success => false, :message=>"fail to change nickname. no user found"}
      return      
    end

    if (@user.nick_count > 2)
      render :json=>{:success => true, :result_code => 1, :message=>"max nick count"}
      return
    end

    @new_nick_count = @user.nick_count + 1

    if (@user.update_attributes(:nickname => @new_nick_name, :nick_count => @new_nick_count))
      render :json=>{:success => true, :result_code => 0, :message=>"success to change nickname"}
      return
    else
      render :json=>{:success => false, :result_code => 2, :message=>"fail to change nickname"}
      return      
    end
  end

  
  # def alertUser
  #   @imei = params[:imei]
  #   @nickname = params[:nickname]
  #   @user = User.getUserInfo(@imei)

  #   @alert_user = User.getUserInfoByNickname(@nickname)
  #   if (@user.nil?)
  #     render :json=>{:success => false, :message=>"fail to alert user. no me found"}
  #     return      
  #   end

  #   if (@alert_user.nil?)
  #     render :json=>{:success => false, :message=>"fail to alert user. no alert target user found"}
  #     return      
  #   end

  #   # if (@user.voted_down_on? @alert_user)
  #   #   render :json=>{:success => false, :result_code => 1, :message=>"already alert user"}
  #   #   return
  #   # end

  #   if (@alert_user.downvote_from @user)
  #     newCount = @alert_user.downvotes.size
  #   # if (@user.down_votes @alert_user)
  #     render :json=>{:success => true, :alert_count=> newCount, :message=>"success to update alert count. current alert #{newCount}"}
  #   else
  #     render :json=>{:success => false, :result_code => 2, :message=>"fail to update alert count."}
  #   end
  # end
end
