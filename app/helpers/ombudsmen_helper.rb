module OmbudsmenHelper

  def ombudsmen_kinds_for_select
    Ombudsman.kinds.keys.map {|o| [I18n.t("ombudsman.kinds.#{o}"), o ]}
  end
end
