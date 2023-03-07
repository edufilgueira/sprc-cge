class PPA::Photo < PPA::Attachment
  attachment :attachment, content_type: %w{ image/jpeg  image/jpg image/png image/gif image/bmp }
end
