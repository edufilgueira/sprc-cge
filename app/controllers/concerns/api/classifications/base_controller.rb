module Api::Classifications::BaseController
  extend ActiveSupport::Concern
  include Api::BaseController

  PER_PAGE_DEFAULT = 25

  included do
    def subtopics
      subtopics_mapped = map_by_title(subtopics_by_topic_for_select(topic))
      resources = blank_option.merge(subtopics_mapped)
       object_response(resources)
    end
  end

  private

  def blank_option
    { "#{I18n.t('messages.form.select')}": ''  }
  end

  def topic
    params[:topic]
  end

  def subtopics_by_topic_for_select(topic)
    sorted_subtopics.where(topic: topic)
  end

  def sorted_subtopics
    Subtopic.enabled.sorted
  end

  def map_by_title(resources)
    resources.map { |r| [r.title, r.id] }.to_h
  end

  def response_paginated(objects)
    filterd_count = objects.size
    resources = objects_for_select(paginate_objects(objects))

    object_paginated_response(resources, filterd_count)
  end

  def filter_objects(scope, organ, subnet=nil)
    scope = sorted_objects(scope)

    scope =
      if subnet.present?
        objects_by_subnet(subnet, scope)
      else
        objects_by_organ(organ, scope)
      end

    scope = not_other_organs(scope)
    scope = no_characteristic(scope) unless scope.table_name == "service_types"
    scope = objects_search_by_name_organ(scope) if search_param.present?
    scope.enabled.sorted
  end

  def sorted_objects(scope)
    scope.enabled.sorted
  end

  def objects_by_organ(organ, objects)
    return objects.where(organ: nil) if organ.blank?

    objects.where(organ: [nil, organ])
  end

  def objects_by_subnet(subnet, objects)
    objects.where('organ_id IS NULL OR subnet_id = ?', subnet)
  end

  def not_other_organs(scope)
    scope.not_other_organs
  end

  def no_characteristic(scope)
    scope.without_no_characteristic
  end

  def objects_search_by_name_organ(objects)
    object_name = objects.table_name
    objects.left_joins(:organ)
      .where("LOWER(organs.acronym) LIKE LOWER(?) OR
        LOWER(#{object_name}.name) LIKE LOWER(?)",
        "%#{search_param}%", "%#{search_param}%")
      .order("organs.name, name")
  end

  def paginate_objects(objects)
    objects.page(page_param).per(per_page_param)
  end

  def objects_for_select(objects)
    objects_mapped = map_by_title(objects)

    objects_mapped = blank_option.merge(objects_mapped) if page_param == '1'
    objects_mapped
  end

  def organ
    params[:organ]
  end

  def denunciation_organ
    params[:denunciation_organ]
  end

  def page_param
    params[:page] || '1'
  end

  def per_page_param
    params[:per_page] || PER_PAGE_DEFAULT
  end

  def search_param
    params[:term]
  end
end
