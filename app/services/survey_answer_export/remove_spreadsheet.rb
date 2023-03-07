class SurveyAnswerExport::RemoveSpreadsheet

  attr_accessor :filepath

  def self.call(filepath)
    new(filepath).call
  end

  def initialize(filepath)
    @filepath = filepath
  end

  def call
    remove_file
  end

  # privates

  private

  def remove_file
    FileUtils.rm_rf(filepath) if File.exist?(filepath)
  end
end
