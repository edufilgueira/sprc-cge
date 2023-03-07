module FormHelper


  def yes_or_no_for_select
    [
      [ I18n.t("boolean.true"), true ],
      [ I18n.t("boolean.false"), false ]
    ]
  end

end
