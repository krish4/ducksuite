module Requests
  module UserHelpers
    def login_user(user)
      post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
    end
  end

  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module UtilsHelpers
    def with_modified_env(options, &block)
      ClimateControl.modify(options, &block)
    end
  end
end