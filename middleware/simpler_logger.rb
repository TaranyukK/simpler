class SimplerLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    status, headers, body = @app.call(@env)

    log = create_log(status, headers, body)
    write_log(log)

    [status, headers, body]
  end

  private

  def create_log(status, headers, _body)
    "
      Request: #{@env['REQUEST_METHOD']}
      Handler: #{controller_info}##{action_info}
      Parameters: #{parameters_info}
      Response: #{status} [#{headers['Content-Type']}] #{template_info}
    "
  end

  def controller_info
    @env['simpler.controller'].class.name
  end

  def action_info
    @env['simpler.action']
  end

  def parameters_info
    @env['rack.request.query_hash']
  end

  def template_info
    @env['simpler.template']
  end

  def write_log(log)
    File.open(Simpler.root.join('log/app.log'), 'a') do |file|
      file.write(log)
    end
  end
end
