OmniAuth.config.on_failure = SessionsController.action(:omniauth_failure)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, CLIENT_ID, CLIENT_SECRET,
           {:scope => GOOGLE_SCOPES.join(" "), :approval_prompt=>"auto", :access_type=>"offline"}
end