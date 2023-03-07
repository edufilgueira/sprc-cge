module EvaluationFormHelper
  
  def first_question_fields_concated(used_input, evaluation_type, messages)

    t_base = 'shared.answers.evaluations.questions'

    first_question_fields = [:question_01_a, :question_01_b, :question_01_c, :question_01_d]

    first_question_field_concateds = []
    
    first_question_fields.each do |field_name|
      question_desc = t("#{t_base}.#{evaluation_type}.#{field_name}.description")
      
      evaluation_error = messages[field_name]
      
      question_desc = change_question_desc(field_name, question_desc, used_input)

      first_question_field_concateds.push(
        {
          question_description: question_desc, 
          field_name: field_name, 
          evaluation_error: evaluation_error
        }
      )
    end
    
    first_question_field_concateds
  end

  private
  
  def change_question_desc(field_name, question_desc, used_input)
    
    return question_desc if field_name != :question_01_c

    used_input = Ticket.human_attribute_name("ticket.used_input.#{used_input}")
    question_desc.gsub("[used_input]", used_input)
  end

end
