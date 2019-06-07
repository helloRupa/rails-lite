require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params, :flash

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @already_built_response = false
    @flash = Flash.new(req)
    flash.store_flash(res) # clear existing cookie if there is one
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'Already responded' if already_built_response?
    flash.store_flash(res)
    res['Location'] = url
    res.status = 302
    @already_built_response = true
    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Already responded' if already_built_response?
    
    res['Content-Type'] = content_type
    res.write(content)
    @already_built_response = true
    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.join('views', self.class.name.underscore, "#{template_name}.html.erb")
    file = File.read(path)
    @flash = flash.now unless flash.now.empty?
    render_content(ERB.new(file).result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    self.render(name.to_s) unless already_built_response?
  end
end

