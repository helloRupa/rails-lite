require 'json'

class Session
  attr_reader :cookie_data, :cookie_name
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookie_name = '_rails_lite_app'
    cookie = req.cookies[cookie_name]

    unless cookie
      @cookie_data = {}
    else
      @cookie_data = JSON.parse(cookie)
    end
  end

  def [](key)
    cookie_data[key]
  end

  def []=(key, val)
    cookie_data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(cookie_name, { path: '/', value: cookie_data.to_json })
  end
end
