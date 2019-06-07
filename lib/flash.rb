require 'json'

class Flash
  attr_reader :flash, :cookie_name, :req, :temp

  def initialize(req)
    @cookie_name = '_rails_lite_app_flash'
    @flash = {}
    @temp = {}
    @req = req
  end

  def [](key)
    cookie = req.cookies[cookie_name]
    if cookie
      cookie_val = JSON.parse(cookie)
      return cookie_val[key.to_s]
    end
    flash[key.to_s] || temp[key.to_s]
  end

  def []=(key, value)
    flash[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie(cookie_name, { path: '/', value: flash.to_json })
  end

  def now
    temp
  end
end
