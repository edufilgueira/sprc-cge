# Shared example para assets por action nos shared controllers

shared_examples_for 'controllers/shared/assets' do

  describe 'action assets' do

    it 'stylesheet' do
      # ex: 'views/shared/home/index'
      expected = "views/#{controller.send(:controller_base_view_path)}/#{controller.action_name}"
      expect(controller.stylesheet).to eq(expected)
    end

    it 'javascript' do
      # ex: 'views/shared/home/index'
      expected = "views/#{controller.send(:controller_base_view_path)}/#{controller.action_name}"
      expect(controller.javascript).to eq(expected)
    end
  end

end
