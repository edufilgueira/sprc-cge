module PPA
  module Revision
    module ParticipantProfileHelper

      # TODO: Refatorar os metodos de select para ficar generico e atendendo a todos os casos
      # Todos seguem a mesma estrutura

      def participant_profile_ages_for_select
        ages_keys.map do |age|
          [age_title(age), age].sort
        end
      end

      def participant_profile_genre_for_select
        genres = genre_keys.map do |genre|
          [genre_title(genre), genre].sort
        end
        genres.sort
      end

      def participant_profile_sexual_orientation_for_select
        orientations = sexual_orientation_keys.map do |sexual_orientation|
          [sexual_orientation_title(sexual_orientation), sexual_orientation].sort
        end
        orientations.sort
      end

      def participant_profile_deficiency_for_select
        deficiencies = deficiency_keys.map do |deficiency|
          [deficiency_title(deficiency), deficiency].sort
        end
        deficiencies.sort
      end

      def participant_profile_breed_for_select
        breeds = breed_keys.map do |breed|
          [breed_title(breed), breed]
        end
        breeds.sort
      end

      def participant_profile_ethnic_group_for_select
        ethnic_groups = ethnic_group_keys.map do |ethnic_group|
          [ethnic_group_title(ethnic_group), ethnic_group].sort
        end
        ethnic_groups.sort
      end

      def participant_profile_educational_level_for_select
        educational_level_keys.map do |educational_level|
          [educational_level_title(educational_level), educational_level].sort
        end
      end

      def participant_profile_family_income_for_select
        family_income_keys.map do |family_income|
          [family_income_title(family_income), family_income].sort
        end
      end

      def participant_profile_representative_for_select
        representative_keys.map do |representative|
          [representative_title(representative), representative].sort
        end
      end

      def ages_keys
        resource_klass.ages.keys
      end

      def genre_keys
        resource_klass.genres.keys
      end

      def sexual_orientation_keys
        resource_klass.sexual_orientations.keys
      end

      def deficiency_keys
        resource_klass.deficiencies.keys
      end

      def breed_keys
        resource_klass.breeds.keys
      end

      def ethnic_group_keys
        resource_klass.ethnic_groups.keys
      end

      def educational_level_keys
        resource_klass.educational_levels.keys
      end

      def family_income_keys
        resource_klass.family_incomes.keys
      end

      def representative_keys
        resource_klass.representatives.keys
      end

      def age_title(age)
        I18n.t("ppa.revision.participant_profile/ages.#{age}")
      end

      def genre_title(genre)
        I18n.t("ppa.revision.participant_profile/genres.#{genre}")
      end

      def sexual_orientation_title(sexual_orientation)
        I18n.t("ppa.revision.participant_profile/sexual_orientations.#{sexual_orientation}")
      end

      def deficiency_title(deficiency)
        I18n.t("ppa.revision.participant_profile/deficiencies.#{deficiency}")
      end

      def breed_title(breed)
        I18n.t("ppa.revision.participant_profile/breeds.#{breed}")
      end

      def ethnic_group_title(breed)
        I18n.t("ppa.revision.participant_profile/ethnic_groups.#{breed}")
      end

      def educational_level_title(educational_level)
        I18n.t("ppa.revision.participant_profile/educational_levels.#{educational_level}")
      end

      def family_income_title(family_income)
        I18n.t("ppa.revision.participant_profile/family_incomes.#{family_income}")
      end

      def representative_title(representative)
        I18n.t("ppa.revision.participant_profile/representatives.#{representative}")
      end
    end
  end
end
