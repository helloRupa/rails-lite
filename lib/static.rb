class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    fpath = /.+public\/(.+)/.match(req.path)[1]
    ext = /.+\.(\w+)/.match(fpath)
    file = File.read("public/#{fpath}")

    ["200", {'Content-type' => "image/#{ext}"}, [file]]
  rescue Exception => err
    [404, {'Content-type' => "text/html"}, [err.message]]
  ensure
    app.call(env)
  end
end
