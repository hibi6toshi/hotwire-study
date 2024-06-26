class CatsController < ApplicationController
  before_action :set_cat, only: %i[ show edit update destroy ]

  # GET /cats
  def index
    @search = Cat.ransack(params[:q])

    # デフォルトのソートをid降順にする
    @search.sorts = 'id desc' if @search.sorts.empty?

    @cats = @search.result.page(params[:page])
  end

  # GET /cats/1
  def show
  end

  # GET /cats/new
  def new
    @cat = Cat.new
  end

  # GET /cats/1/edit
  def edit
  end

  # POST /cats
  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      # 暗黙的に create.turbo_stream.erbのrenderが実行される。
      flash.now.notice = 'ねこを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cats/1
  def update
    if @cat.update(cat_params)
      # リダイレクトを削除（リダイレクトがないと暗黙的に`render`が実行される）
      # redirect_to @cat, notice: "ねこを更新しました。", status: :see_other

      # Flashは通常だとリダイレクト時に使うのでflash.noticeを使って設定する。
      # でもTurbo Streamsでは今回のリクエストに対してFlashを設定したい。そういう場合には今回のリクエストに対してだけ有効なflash.now.noticeを利用するよ。
      flash.now.notice = 'ねこを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /cats/1
  def destroy
    @cat.destroy!
    # 暗黙的に render destroy.turbo_stream.erb　をしている。
    flash.now.notice = 'ねこを削除しました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cat
      @cat = Cat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cat_params
      params.require(:cat).permit(:name, :age)
    end
end
