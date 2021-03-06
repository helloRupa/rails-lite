require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  rescue Exception => err
    render_exception(err)
  end

  private

  def render_exception(e)
    ["500", {'Content-type' => 'text/html'}, [e.message, " <br>", e.backtrace.join("<br>")]]
  end

end
