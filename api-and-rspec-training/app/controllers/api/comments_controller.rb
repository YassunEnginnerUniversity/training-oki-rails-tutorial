class Api::CommentsController < ApplicationController
  before_action :authenticate_user! # セッションを保持しているかアクションの前に確認

  # 例外処理 JSON以外のリクエストが来たときの場合
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error
  # 例外処理 パラメータが不正なリクエストの場合（requireで指定してるパラメータ）
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  # 例外処理（findは、値が取得できなかった場合にActiveRecord::RecordNotFoundを返す）
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    if comment_params[:content].blank?
      return render json: { error: "コメントが空です。" }, status: :unprocessable_entity
    end

    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render :create
    else
      if @comment.errors[:content].include?("255字以上はコメントできません")
        render json: { error: "120字以上はコメントできません" }, status: :unprocessable_entity
      elsif @comment.errors[:content].include?("内容を入力してください")
        render json: { error: "内容を入力してください" }, status: :unprocessable_entity
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
