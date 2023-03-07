# Shared example para assets por action nos controllers

shared_examples_for 'controllers/base/assets' do

  describe 'action assets' do

    it 'stylesheet' do
      # ex: 'views/home/index'
      expected = "views/#{controller.controller_path}/#{controller.action_name}"
      expect(controller.stylesheet).to eq(expected)
    end

    it 'javascript' do
      # ex: 'views/home/index'
      expected = "views/#{controller.controller_path}/#{controller.action_name}"
      expect(controller.javascript).to eq(expected)
    end
  end

end
