class Api::V1::Platform::TopicsController < Api::V1::PlatformController
  include Api::Classifications::BaseController

  def topics
    topics = filter_objects(Topic, organ)
    response_paginated(topics)
  end
end
