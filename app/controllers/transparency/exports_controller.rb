class Transparency::ExportsController < TransparencyController

  FIND_ACTIONS = ['download']

  # Actions

  def download
    respond_to do |format|
      format.xlsx {
        send_file(resource.filepath, filename: resource.filename, type: 'application/xlsx')
      }
    end
  end

  # Private

  private

  def resource_klass
    Transparency::Export
  end
end
