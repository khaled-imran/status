class PageUpdatesController < ApplicationController
  include ActionController::Live
  before_action :authenticate_user!

  def create
    response.headers['Content-Type'] = 'text/javascript'
    page_update = current_user.page_updates.create(content: params['content'])
    $redis.publish('page_updates.create', { email: page_update.user.email, content: page_update.content, time: page_update.time_string }.to_json )
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'

    redis = Redis.new
    redis.subscribe('page_updates.create') do |on|
      on.message do |event, data|
        response.stream.write("data: #{data}\n\n")
        response.stream.write("event: custom_alert\ndata: #{data}\n\n")
      end
    end

  rescue IOError
    logger.info 'Stream Closed' # in case if the browser is closed
  ensure
    redis.quit
    response.stream.close
  end

end
