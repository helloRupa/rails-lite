class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    serve_file(env)
  rescue Exception => err
    bad_path(err)
  ensure
    app.call(env)
  end

  private

  def file_path(env)
    req = Rack::Request.new(env)
    /.+public\/(.+)/.match(req.path)[1]
  end

  def serve_file(env)
    fpath = file_path(env)
    ext = /.+\.(\w+)/.match(fpath)
    file = File.read("public/#{fpath}")

    ["200", {'Content-type' => "image/#{ext}"}, [file]]
  end

  def bad_path(err)
    [404, {'Content-type' => 'text/html'}, [err.message]]
  end
end
