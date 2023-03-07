namespace :topics do
  task create_or_update: :environment do

    topics_data = [
      {
        name: 'Não compete ao Poder Executivo Estadual',
        other_organs: true,
        subtopics_data: [
          {
            name: 'Não compete ao Poder Executivo Estadual',
            other_organs: true
          }
        ]
      },

      {
        name: 'Solicitação de segunda via de conta de água'
      },

      {
        name: 'Solicitação de segunda via de multa de trânsito',
        organ: Organ.find_by(acronym: 'DETRAN'),
        subtopics_data: [
          {
            name: 'Multas leves e médias'
          },
          {
            name: 'Multas graves'
          }
        ]
      }
    ]

    topics_data.each do |topic_data|
      topic = Topic.find_or_initialize_by(name: topic_data[:name])

      subtopics_data = topic_data.delete(:subtopics_data)

      topic.update_attributes!(topic_data)

      next if subtopics_data.blank?
      subtopics_data.each do |subtopic|
        topic.subtopics.find_or_create_by(name: subtopic[:name])
      end
    end
  end
end
