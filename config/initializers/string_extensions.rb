# encoding: utf-8
module StringExtensions
  # ignored in titleize_with_accents
  IGNORED_PREPOSITIONS = %w(da das de do dos e)

  def downcase_with_accent_support
    self.tr("À", "à")
      .tr("Á", "á")
      .tr("Â", "â")
      .tr("Ã", "ã")
      .tr("Ä", "ä")
      .tr("È", "è")
      .tr("É", "é")
      .tr("Ê", "ê")
      .tr("Ë", "ë")
      .tr("Ì", "ì")
      .tr("Í", "í")
      .tr("Î", "î")
      .tr("Ï", "ï")
      .tr("Ò", "ò")
      .tr("Ó", "ó")
      .tr("Ô", "ô")
      .tr("Õ", "õ")
      .tr("Ö", "ö")
      .tr("Ù", "ù")
      .tr("Ú", "ú")
      .tr("Û", "û")
      .tr("Ü", "ü")
      .tr("Ç", "ç")
      .downcase
  end
  alias :downcase_with_accents :downcase_with_accent_support


  def titleize_with_accent_support
    titleized = self.gsub(/-/, '{{dash}}')
                    .downcase_with_accent_support
                    .titleize
                    .gsub('{{Dash}}', '-')
                    .gsub(/(^|\s|\(|\-)à/, "\\1À")
                    .gsub(/(^|\s|\(|\-)á/, "\\1Á")
                    .gsub(/(^|\s|\(|\-)â/, "\\1Â")
                    .gsub(/(^|\s|\(|\-)ã/, "\\1Ã")
                    .gsub(/(^|\s|\(|\-)ä/, "\\1Ä")
                    .gsub(/(^|\s|\(|\-)è/, "\\1È")
                    .gsub(/(^|\s|\(|\-)é/, "\\1É")
                    .gsub(/(^|\s|\(|\-)ê/, "\\1Ê")
                    .gsub(/(^|\s|\(|\-)ë/, "\\1Ë")
                    .gsub(/(^|\s|\(|\-)ì/, "\\1Ì")
                    .gsub(/(^|\s|\(|\-)í/, "\\1Í")
                    .gsub(/(^|\s|\(|\-)î/, "\\1Î")
                    .gsub(/(^|\s|\(|\-)ï/, "\\1Ï")
                    .gsub(/(^|\s|\(|\-)ò/, "\\1Ò")
                    .gsub(/(^|\s|\(|\-)ó/, "\\1Ó")
                    .gsub(/(^|\s|\(|\-)ô/, "\\1Ô")
                    .gsub(/(^|\s|\(|\-)õ/, "\\1Õ")
                    .gsub(/(^|\s|\(|\-)ö/, "\\1Ö")
                    .gsub(/(^|\s|\(|\-)ù/, "\\1Ù")
                    .gsub(/(^|\s|\(|\-)ú/, "\\1Ú")
                    .gsub(/(^|\s|\(|\-)û/, "\\1Û")
                    .gsub(/(^|\s|\(|\-)ü/, "\\1Ü")
                    .gsub(/(^|\s|\(|\-)ç/, "\\1Ç")

    # reverting prepositions
    IGNORED_PREPOSITIONS.each do |prep|
      titleized.gsub!(" #{prep} ".titleize, " #{prep} ")
    end

    titleized
  end
  alias :titleize_with_accents :titleize_with_accent_support

end

String.send(:include, StringExtensions)
