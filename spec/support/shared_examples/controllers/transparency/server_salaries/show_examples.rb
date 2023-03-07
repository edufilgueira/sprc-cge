# Shared example para action show de transparency/server_salaries

shared_examples_for 'controllers/transparency/server_salaries/show' do

  let(:server_salary) { create(:integration_servers_server_salary) }

  describe '#show' do

    before { get(:show, params: { id: server_salary }) }

    context 'template' do
      render_views

      it 'responds with success and renders templates' do
        expect(response).to be_success
        expect(response).to render_template("shared/transparency/server_salaries/show")
      end
    end

    context 'assets' do
      it 'javascript' do
        expected = "views/shared/transparency/server_salaries/show"
        expect(controller.javascript).to eq(expected)
      end
    end

    it 'server_salary instance' do
      expect(controller.server_salary).to eq(server_salary)
    end

    describe 'xhr' do

      # Usado como ajax no seletor de mês.
      it 'does not render layout and renders only _show partial' do
        get(:show, params: { id: server_salary.id }, xhr: true)

        expect(response).not_to render_template('application')
        expect(response).not_to render_template('show')
        expect(response).to render_template(partial: '_show')
      end
    end

    describe 'helpers' do
      it 'all_server_salaries' do
        # deve retornar todas as server_salaries, garantido que a passada
        # como parâmetro no show seja a primeira para renderizar as abas de
        # matrículas.

        server = server_salary.server
        registration = server_salary.registration

        another_registration = create(:integration_servers_registration, server: server)
        another_server_salary = create(:integration_servers_server_salary, registration: another_registration, date: server_salary.date)

        ignored_server_salary = create(:integration_servers_server_salary, registration: another_registration, date: server_salary.date - 2.months)

        get(:show, params: { id: another_server_salary.id })

        expect(controller.all_server_salaries).to eq([another_server_salary, server_salary])
      end
    end
  end
end
