module AttachmentsHelper

  IMAGE_SIZE = {
    smaller: 30,
    small: 48,
    normal: 90
  }

  def document_url(attachment)
    attachment_url(attachment, :document)
  end

  def document_image_tag(attachment, size)
    image_size = IMAGE_SIZE[size]

    return default_document_image_tag(image_size) unless image?(attachment)

    image_tag(attachment_url(attachment, :document, :fill, image_size, image_size))
  end

  private

  def image?(attachment)
    extension = document_extension(attachment)

    %w( jpeg gif png jpg bmp ).include?(extension)
  end

  def document_extension(attachment)
    attachment.document_attacher.extension
  end

  def default_document_image_tag(image_size)
    image_tag("document.png", width: image_size, height: image_size)
  end
end
