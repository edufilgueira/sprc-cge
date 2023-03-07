# Shared example básico para models que incluem Disableable

shared_examples_for 'models/disableable' do
  let(:factory) { described_class.to_s.underscore }
  let(:resource) { create(factory) }
  let(:resource_disabled) { create(factory, disabled_at: DateTime.now) }


  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }
    end
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:_disable) }
    it { is_expected.to respond_to(:_disable=) }
  end

  context 'scope' do
    it 'disabled' do
      expect(described_class.disabled).to eq([resource_disabled])
    end

    it 'enabled' do
      expect(described_class.enabled).to eq([resource])
    end
  end

  context 'helpers' do
    it 'disable!' do
      resource.disable!
      expect(resource).to be_disabled
    end

    it 'enable!' do
      resource_disabled.enable!
      expect(resource_disabled).to be_enabled
    end

    context 'set_disabled_at' do
      context 'when _disable = 0' do
        before do
          resource._disable = '0'
          resource.set_disabled_at
        end

        it {expect(resource).not_to be_disabled }
      end

      context 'when _disable = 1' do
        before do
          resource._disable = '1'
          resource.set_disabled_at
        end

        it {expect(resource).to be_disabled }
      end

      context 'when _disable = nil' do

        context 'when not disabled' do
          before do
            resource.enable!
            resource.set_disabled_at
          end

          it {expect(resource).not_to be_disabled }
        end

        context 'when already disabled' do
          before do
            resource.disable!
            resource.set_disabled_at
          end

          it {expect(resource).to be_disabled }
        end
      end
    end
  end
end
