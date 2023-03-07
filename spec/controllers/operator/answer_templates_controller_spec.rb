require 'rails_helper'

describe Operator::AnswerTemplatesController do

  let(:user) { create(:user, :operator) }

  let(:resources) { create_list(:answer_template, 2, user: user) }

  let(:permitted_params) do
    [
      :name,
      :content
    ]
  end

  let(:valid_params) do
    {
      answer_template: attributes_for(:answer_template)
    }
  end

  it_behaves_like 'controllers/operator/base/index' do
    it_behaves_like 'controllers/operator/base/index/xhr'
    it_behaves_like 'controllers/operator/base/index/paginated'
    it_behaves_like 'controllers/operator/base/index/search'

    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          name: 'answer_templates.name'
        }
      end

      let(:first_unsorted) do
        create(:answer_template, name: '456')
      end

      let(:last_unsorted) do
        create(:answer_template, name: '123')
      end
    end
  end

  it_behaves_like 'controllers/operator/base/new'

  it_behaves_like 'controllers/operator/base/create'

  it_behaves_like 'controllers/operator/base/show'

  it_behaves_like 'controllers/operator/base/edit'

  it_behaves_like 'controllers/operator/base/update'

  it_behaves_like 'controllers/operator/base/destroy'
end
