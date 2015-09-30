class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.desc(:id)
  end

  def top
    @users = User.all.desc(:indice).limit(5).reject{|m| m == User.last}.take(4)
    render json: @users
  end

  def all
    @users = User.all.desc(:indice).reject{|m| m.name == "NEW PLAYER"}
    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def last
    @user = User.last
    @user.male = (params['male'] == '1') if params['male']
    @user.save
    render json: @user
  end

  def lastClassified
    render json: User.all.desc(:id)[1]
  end

  def active
    @user = User.last
    @user.active = (params['v'] == '1') if params['v']
    @user.save
    render json: @user
  end

  def newUser
    last = User.last
    last.active = 0
    last.save
    if last.name != "NEW PLAYER"
      @user = User.new
      @user.save
    end
    render json: @user
  end

  def reset
    @user = User.last
    @user.flow = Array.new
    @user.thermal = Array.new
    @user.temp = Array.new
    @user.stress = Array.new
    @user.conductance = Array.new
    @user.galvanicVoltage = Array.new
    @user.heartRate = Array.new
    @user.save
    render json: @user
  end

  def updateControl
    @user = User.last
    @user.runningTime = params['runningTime'].to_i if params['runningTime']
    @user.indice = params['indice'].to_i if params['indice']

    @user.stress = Array.new if @user.stress.nil?
    @user.conductance = Array.new if @user.conductance.nil?
    @user.galvanicVoltage = Array.new if @user.galvanicVoltage.nil?
    @user.temp = Array.new if @user.temp.nil?
    @user.flow = Array.new if @user.flow.nil?
    @user.thermal = Array.new if @user.thermal.nil?

    if @user.active

      @user.update_temp params['temperature']
    
      @user.conductance << params['conductance'].to_f if params['conductance']
      @user.conductance.shift if @user.conductance.count > 1200

      @user.galvanicVoltage << params['galvanicVoltage'].to_f if params['galvanicVoltage']
      @user.galvanicVoltage.shift if @user.galvanicVoltage.count > 1200
      

      @user.stress << params['stress'].to_f if params['stress']
      @user.stress.shift if @user.stress.count > 1200


      @user.flow << params['flow'].to_f if params['flow']
      @user.flow.shift if @user.flow.count > 1200

      @user.thermal << params['thermal'].to_f if params['thermal']
      @user.thermal.shift if @user.thermal.count > 1200
    end

    @user.save
    render json: @user
  end

  def heartRate
    @user = User.last
    @user.heartRate = Array.new if @user.heartRate.nil?
    @user.heartRate << params['v'].to_f if params['v']
    @user.heartRate.shift if @user.heartRate.count > 1200
    
    @user.save
    render json: @user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit!
    end
end
