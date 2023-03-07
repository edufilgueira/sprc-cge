class Ticket::Solvability::SectoralService < Ticket::Solvability::GeneralService

  private

  def replied_and_expired_scope(scope)
    replied_scope(scope).where('answers.sectoral_deadline < 0')
  end

  def replied_and_not_expired_scope(scope)
    replied_scope(scope).where('answers.sectoral_deadline >= 0')
  end
end
