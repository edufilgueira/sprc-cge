##
# Remove planilha de chamados. É chamado antes do destroy de um export ou report.
#
##

class RemoveReportableSpreadsheet

  # Attributes

  attr_reader :reportable

  def initialize(reportable)
    @reportable = reportable
  end

  def call
    remove_dir
  end

  def self.call(reportable)
    new(reportable).call
  end

  private

  def remove_dir
    FileUtils.rm_rf(reportable_dir_path) if File.exist?(reportable_dir_path)
  end

  def reportable_dir_path
    reportable.dir_path
  end
end
