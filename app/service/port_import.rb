class PortImport < ApplicationService
  attr_reader :input_file, :user

  def initialize input_file, user
    @input_file = input_file
    @user = user
  end

  def call
    success, error_post, row = Post.import input_file, user
    if success
      handle_import_success
    else
      handle_import_error row, error_post
    end
  end

  private

  def handle_import_error row, error_post
    if error_post.is_a? Post
      flash[:danger] =
        "#{t('import_failed_at_row',
             row:)}:<br>#{show_all_errors(error_post).join('<br>')}"
    else
      flash[:danger] =
        "#{t('import_failed_at_row', row:)}: #{t('wrong_format')}"
    end
    redirect_to user_posts_path(current_user)
  end

  def handle_import_success
    flash[:success] = t "import_success"
    redirect_to user_posts_path(current_user)
  end
end
