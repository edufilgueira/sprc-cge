class Admin::TopicsController < Admin::BaseCrudController
  include Admin::Topics::Breadcrumbs
  include Admin::FilterDisabled

  PERMITTED_PARAMS = [
    :name,
    :organ_id,
    subtopics_attributes: [
      :id,
      :name,
      :_disable
    ]
  ]

  FILTERED_ASSOCIATIONS = [:organ]

  SORT_COLUMNS = {
    name: 'topics.name',
    email: 'topics.email',
    organ_name: 'organs.name'
  }

  FIND_ACTIONS = FIND_ACTIONS + ['delete']

  helper_method [:topics, :topic, :subtopics]

  # Actions

  def delete
  end

  def destroy
    if DeleteTopicService.call(topic, params[:target_topic], params[:target_subtopics])
      flash[:notice] = t('.done', title: topic.title)
      redirect_to admin_topics_path
    else
      flash.now[:alert] = t('.error')
      render :delete
    end
  end

  # Helper methods

  def topics
    paginated_resources
  end

  def topic
    resource
  end

  def subtopics
    resource.subtopics.sorted
  end
end
