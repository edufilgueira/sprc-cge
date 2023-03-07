module PPA
  class PlanValidator < ActiveModel::Validator

    def validate(record)
      @record = record

      end_year_greater_than_start_year
      unique_plan_ranges
      proposal_dates_range
      voting_dates_range
      duration
    end

    private

    def duration
      return unless @record.start_year && @record.end_year
      duration = @record.end_year - @record.start_year + 1 # em anos

      if duration != PPA::Plan::DURATION
        @record.errors.add(:end_year, :invalid_duration, duration: PPA::Plan::DURATION)
      end
    end

    def end_year_greater_than_start_year
      return unless @record.start_year && @record.end_year
      @record.errors.add(:end_year, :invalid) if @record.end_year <= @record.start_year
    end

    def proposal_dates_range
      validate_range(:proposal)
    end

    def voting_dates_range
      validate_range(:voting)
    end

    def validate_range(kind) 
      return unless @record.end_year      
    end

    def unique_plan_ranges
      return unless @record.start_year && @record.end_year
      return unless max_plan = @record.class.order(:end_year).first
      @record.errors.add(:base, :invalid_range) if @record.start_year <= max_plan.end_year && @record != max_plan
    end

  end
end
