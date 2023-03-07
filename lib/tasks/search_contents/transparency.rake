# Rake para criar os resultados de busca padrão

namespace :search_contents do
  namespace :transparency do
    desc 'Cria ou atualiza os resultados de busca'
    task create_or_update: :environment do

      search_contents = [
        {
          title: 'Informações sobre Servidores Públicos',
          description: 'Consulte informações sobre servidores estaduais ativos, inativos e pensionistas, pesquisando por nome, orgão ou cargo.',
          content: 'salario salário servidores pensionista transparencia transparência',
          link: 'portal-da-transparencia/servidores',
          locale: 'pt-BR'
        },

        {
          title: 'Contratos',
          description: 'Consulte aqui qualquer contrato firmado pelo Estado. Veja quem foi contratado, qual o serviço que deve ser feito, quanto já foi pago, a data de conclusão etc.',
          content: 'contrato transparencia transparência',
          link: 'portal-da-transparencia/contratos/contratos',
          locale: 'pt-BR'
        },

        {
          title: 'Convênios',
          description: 'Consulte aqui qualquer convênio firmado pelo Estado. Veja aqui os convênios com a prefeitura de seu município ou convênios de outras entidades. Saiba qual o serviço que deve ser feito, quanto já foi pago, a data de conclusão etc.',
          content: 'convenio transparencia transparência',
          link: 'portal-da-transparencia/contratos/convenios',
          locale: 'pt-BR'
        },

        {
          title: 'Ouvidoria',
          description: 'Faça aqui uma sugestão, elogio, denúncia, reclamação ou solicite algum serviço',
          content: 'ouvidoria denuncia reclamacao sugestao elogio solicitacao sou',
          link: 'sign_in?ticket_type=sou',
          locale: 'pt-BR'
        },

        {
          title: 'Acesso à Informação',
          description: 'Não encontrou a informação que queria? Peça aqui..',
          content: 'acesso informacao sic transparencia transparência',
          link: 'sign_in?ticket_type=sic',
          locale: 'pt-BR'
        },

        {
          title: 'Transparência',
          description: 'Consulte informações e dados abertos no Portal da Transparência.',
          content: 'transparencia',
          link: 'portal-da-transparencia',
          locale: 'pt-BR'
        },

        {
          title: 'Receitas',
          description: 'Consulte informações sobre as receitas do Estado.',
          content: 'receitas multas ipva iptu imposto transparencia transparência',
          link: 'portal-da-transparencia/receitas/receitas-do-poder-executivo',
          locale: 'pt-BR'
        },

        {
          title: 'Despesas',
          description: 'Consulte informações sobre as despesas do Estado.',
          content: 'despesa notas empenho transparencia transparência',
          link: 'portal-da-transparencia/receitas/receitas-do-poder-executivo',
          locale: 'pt-BR'
        }
      ]

      search_contents.each do |params|
        I18n.locale = params[:locale]
        search_content = SearchContent.find_or_initialize_by(title: params[:title])
        search_content.assign_attributes(params)

        search_content.save
      end
    end
  end
end
