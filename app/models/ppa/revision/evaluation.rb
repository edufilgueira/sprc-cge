class PPA::Revision::Evaluation < ApplicationRecord
	self.table_name = 'ppa_revision_evaluations'

	belongs_to :user
  belongs_to :plan, class_name: 'PPA::Plan'
  
  ANSWERS = [
  	:very_satisfied, 
  	:neutral, 
  	:very_dissatisfied
  ]

  ANSWERS_SHORT = [:yes, :no, :dont_know]


  enum question1: [:radio, :facebook, :email, :whatsapp, :friends, :instagram, :site, :other]
  enum question2: ANSWERS, _suffix: true
  enum question3: ANSWERS, _suffix: true
  enum question4: ANSWERS, _suffix: true
  enum question5: ANSWERS, _suffix: true
  enum question6: ANSWERS, _suffix: true
  enum question7: ANSWERS, _suffix: true
  enum question8: ANSWERS, _suffix: true
  enum question9: ANSWERS, _suffix: true
  enum question10: ANSWERS_SHORT, _suffix: true

end