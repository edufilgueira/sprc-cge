module PPA
  module WorkshopsHelper

    def workshop_title(workshop)
      date  = workshop.start_at.strftime('%d/%m/%Y')
      name  = workshop.name.capitalize.upcase

      [name, date].join(' - ')
    end

    def workshop_duration(workshop)
      if workshop.start_at.to_date == workshop.end_at.to_date
        date     = _strip_(workshop.start_at, :date)
        start_at = _strip_(workshop.start_at, :time)
        end_at   = _strip_(workshop.end_at, :time)

        t('ppa.workshops_helper.same_duration', date: date, start_at: start_at, end_at: end_at)
      else
        start_at = _strip_(workshop.start_at, :date)
        end_at   = _strip_(workshop.end_at, :date)

        t('ppa.workshops_helper.different_duration', start_at: start_at, end_at: end_at)
      end
    end

    def remaining_time_for_next_workshop(plan_id)
      list_next_workshops = PPA::Workshop.where("plan_id = #{plan_id} and start_at >= '#{Date.current}'")
      if !list_next_workshops.empty?
        start_at_next_workshop = Date.parse(list_next_workshops.order(:start_at).first.start_at.to_s)

        if start_at_next_workshop >= Date.current
          days_remaining = (start_at_next_workshop - Date.current).to_i
          message_days_remaining(days_remaining)
        end

      end
    end

    private

    def _strip_(date, format)
      format = case format
               when :date then '%d/%m/%Y'
               when :time then '%H:%M'
               when :datetime then '%d/%m/%Y %H:%M'
               end

      date.strftime(format)
    end

    def message_days_remaining(days_remaining)
      if days_remaining > 1
        return "#{days_remaining} #{t('ppa.workshops_helper.days')}"
      elsif days_remaining == 0
        t('ppa.workshops_helper.today_is_workshop_day')
      else
        "#{days_remaining} #{t('ppa.workshops_helper.day')}"
      end
    end

  end
end
