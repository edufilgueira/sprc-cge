require 'rails_helper'

describe Transparency::FollowersController do

  # subscribe
  describe '#create' do
    it 'success' do
      transparency_follower_attributes = build(:transparency_follower).attributes

      post(:create, remote: true, params: { transparency_follower: transparency_follower_attributes })

      transparency_follower = controller.transparency_follower

      is_expected.to render_template(
        partial: 'shared/transparency/followers/_show',
        layout: false
      )
    end

    it 'fail' do
      transparency_follower_attributes = build(:transparency_follower, email: '').attributes

      post(:create, remote: true, params: { transparency_follower: transparency_follower_attributes })

      transparency_follower = controller.transparency_follower

      expect(transparency_follower.valid?).to be_falsey

      is_expected.to render_template(
        partial: 'shared/transparency/followers/_form',
        layout: false
      )
    end
  end

  describe '#show' do
    it 'render_template' do
      transparency_follower = create(:transparency_follower)

      get(:show, params: { id: transparency_follower} )

      is_expected.to render_template(
        partial: 'shared/transparency/followers/_show',
        layout: false
      )
    end
  end

  describe '#edit' do
    it 'render_template' do
      transparency_follower = create(:transparency_follower)

      get(:edit, params: { id: transparency_follower} )

      is_expected.to render_template('shared/transparency/followers/edit')
    end
  end

  # unsubscribe
  describe '#updated' do
    it 'mark_as_unsubscribe' do
      transparency_follower = create(:transparency_follower)

      patch(:update, params: { id: transparency_follower })

      is_expected.to render_template('shared/transparency/followers/edit', layout: 'layouts/transparency')
      expect(controller.transparency_follower.unsubscribed_at).to be_present
    end
  end
end
