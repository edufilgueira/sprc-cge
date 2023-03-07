require 'rails_helper'

describe CacheHelper do
  it 'calculates cache_key for model' do
    create_list(:user, 2)

    prefix = 'nome/do/controller/ou/outro/prefixo'
    count = User.count
    max_updated_at = User.maximum(:updated_at).try(:utc).try(:to_s, :number)

    expected = "#{prefix}/#{User.name}-#{count}-#{max_updated_at}"

    expect(helper.cache_key_for(prefix, User)).to eq(expected)
  end

  it 'calculates cache_key for multiple models' do
    create(:user)
    create(:page)

    prefix = 'nome/do/controller/ou/outro/prefixo'

    user_count = User.count
    user_max_updated_at = User.maximum(:updated_at).try(:utc).try(:to_s, :number)
    page_count = User.count
    page_max_updated_at = Page.maximum(:updated_at).try(:utc).try(:to_s, :number)

    expected = "#{prefix}/#{User.name}-#{user_count}-#{user_max_updated_at}/#{Page.name}-#{page_count}-#{page_max_updated_at}"

    expect(helper.cache_key_for(prefix, [User, Page])).to eq(expected)
  end
end
