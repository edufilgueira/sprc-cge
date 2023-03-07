class PPA::Document < PPA::Attachment
  attachment :attachment, extension: %w{ pdf doc docx xls xlsx odt ods }
end
