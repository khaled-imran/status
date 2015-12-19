class PageUpdatesController < ApplicationController
  include ActionController::Live
  before_action :authenticate_user! #, except: [:events]

  def create
    @page_update = current_user.page_updates.create(content: params['content'])
    $redis.publish('page_updates.create', { email: @page_update.user.email, content: @page_update.content }.to_json )
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'

    redis = Redis.new
    redis.subscribe('page_updates.create') do |on|
      on.message do |event, data|
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
    logger.info 'Stream Closed' # in case if the browser is closed
  ensure
    redis.quit
    response.stream.close
  end

  def status_events
    response.headers['Content-Type'] = 'text/event-stream'

    now = Time.now
    messages = PageUpdate.where('created_at > ?', 5.hours.ago)

    # messages.each do |message|
    #   response.stream.write("data:#{message.content},, \n\n")
    #   sleep 2
    # end

    # now = 5.hours.ago
    # 3.times do |n|
    #   response.stream.write("data:#{n},, \n\n")
    #   sleep 2
    # end


  rescue IOError
    logger.info 'Stream Closed' # in case if the browser is closed
  ensure
    # redis.quit
    response.stream.close
  end


end
