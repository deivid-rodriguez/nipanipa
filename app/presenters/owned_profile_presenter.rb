# frozen_string_literal: true

#
# Presentation layer for current user's profile
#
class OwnedProfilePresenter < ApplicationPresenter
  include Profilable

  def actions
    [edit_profile_tab, delete_profile_tab]
  end

  def tabs
    super << messages_tab
  end

  private

  def edit_profile_tab
    {
      # i18n-tasks-use t('shared.profile_header.edit')
      name: action_name("edit"),
      dest: view.edit_user_registration_path,
      class: "pencil"
    }
  end

  def delete_profile_tab
    {
      # i18n-tasks-use t('shared.profile_header.delete')
      name: action_name("delete"),
      dest: view.confirm_delete_account_path,
      class: "trash"
    }
  end

  def messages_tab
    {
      # i18n-tasks-use t('shared.profile_header.messages')
      name: tab_name("messages"),
      path: view.conversations_path
    }
  end
end
