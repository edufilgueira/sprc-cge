#
# Rake para popular a lista de rede de ouvidoria do tipo executivo.
#
# É do tipo 'create_or_update' (chave: title) pois não destrói dados.
#

namespace :ombudsmen do
  namespace :sesa do
    task create_or_update: :environment do

      ombudsmen = [
        {
          title: 'Ouvidoria Geral da Secretaria da Saúde do Estado do Ceará – SESA/CE',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Av. Almirante Barroso, 600, Praia de Iracema – Fortaleza/CE – CEP: 60.060-440',
          phone: '0800 275 1520 / (85) 3101.5227',
          email: 'ouvidoriasesa@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Centro Integrado de Diabetes e Hipertensão – CIDH',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Sílvia Paulet, 2406, Dionísio Torres – Fortaleza/CE – CEP: 60.120-021',
          phone: '(85) 3101.1544',
          email: 'cidhouvidoria@cidh.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Laboratório Central de Saúde Pública – LACEN',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h30 às 17h',
          address: 'Av. Barão de Studart, 2405, Aldeota – Fortaleza/CE – CEP: 60.120-000',
          phone: '(85) 3101.1487',
          email: 'ouvidoria@lacen.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Centro de Saúde Escola - Meireles – CSM',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Av. Antônio Justa, 3113, Meireles – Fortaleza/CE – CEP: 60.165-090',
          phone: '(85) 3101.1443 / 3101-1446',
          email: 'ouvidoria@csmeireles.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Instituto de Prevenção do Câncer – IPC',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'R. Walter Bezerra de Sá, 58, Dionísio Torres – Fortaleza/CE – CEP: 60.135-225',
          phone: '(85) 3101.1459',
          email: 'ouvidoria@ipcc.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital Geral de Fortaleza – HGF',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'Rua Ávila Goulart, 900, Papicu – Fortaleza/CE – CEP: 60.115-290',
          phone: '(85) 3101.3345',
          email: 'ouvidoria@hgf.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital Dr. Carlos Alberto Studart Gomes (Hospital de Messejana)',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'Av. Frei Cirilo, 3480, Messejana – Fortaleza/CE – CEP: 60.864-190',
          phone: '(85) 3101.4158',
          email: 'ouvidoria@hm.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital e Maternidade José Martiniano de Alencar – HMJMA',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: ' Rua Princesa Isabel, 1526, Centro – Fortaleza/CE – CEP: 60.015-061',
          phone: '(85) 3101.4976',
          email: 'ouvidoria@hpm.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital Geral Dr. César Cals – HGCC',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'Avenida do Imperador, 545, Centro – Fortaleza/CE – CEP: 60.015-052',
          phone: '(85) 3101.5319',
          email: 'ouvidoria@hgcc.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital Infantil Albert Sabin – HIAS',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'Rua Tertuliano Sales, 544, Vila União – Fortaleza/CE – CEP: 60.410-790',
          phone: '(85) 3101.4281',
          email: 'ouvidoria@hias.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital São José de Doenças Infecciosas – HSJ',
          operating_hours: 'segunda a sexta-feira, das 7 às 19h',
          address: 'Rua Nestor Barbosa, 315, Parquelândia – Fortaleza/CE – CEP: 60.455-610',
          phone: '(85) 3101.2353',
          email: 'ouvidoria@hsj.ce.gov.br'
        },
        {

          title: 'Hospital de Saúde Mental Professor Frota Pinto – HSM',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Vicente Nobre, S/N, Messejana – Fortaleza/CE – CEP: 60.841-110',
          phone: '(85) 3101.4348',
          email: 'ouvidoria@hsmm.saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hospital Geral Dr. Waldemar de Alcântara – HGWA',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 14 às 17h',
          address: 'Rua Dr. Pergentino Maia, 1559, Messejana – Fortaleza/CE – CEP: 60.840-040',
          phone: '(85) 3216.8305',
          email: 'ouvidoriahgwa@isgh.org.br'
        },
        {

          title: 'Ouvidoria do Hospital Regional do Cariri – HRC',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Catulo da Paixão Cearense, S/N – Juazeiro do Norte/CE – CEP: 63.050-060',
          phone: '(88) 3566.3709',
          email: 'ouvidoriahrc@isgh.org.br'
        },
        {

          title: 'Ouvidoria do Hospital Regional Norte – HRN',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Av. Jonh Sanford Junco, 1505 – Sobral/CE – CEP: 62.030-000',
          phone: '(88) 3677.9509',
          email: 'ouvidoriahrn@isgh.org.br'
        },
        {

          title: 'Ouvidoria do Centro de Referência Nacional em Dermatologia Sanitária Dona Libânia – CSDL',
          operating_hours: 'segunda a sexta-feira, das 7 às 16h',
          address: 'Rua Pedro I, 1033, Centro – Fortaleza/CE – CEP: 60.035-101',
          phone: '(85) 3101.5456',
          email: 'ouvidoriacsdlibania@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Centro Odontológico Tipo II - Joaquim Távora – CEO',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 12 às 16h',
          address: 'Rua Monsenhor Bruno, 2570, Aldeota – Fortaleza/CE – CEP: 60.115.191',
          phone: '(85) 3101.1526',
          email: 'ouvidoriaceojtavora@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Centro de Hematologia e Hemoterapia do Ceará – HEMOCE',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 12 às 19h',
          address: 'Av. José Bastos, 3390, Rodolfo Teófilo – Fortaleza/CE – CEP: 60.440-261',
          phone: '0800.286.2296 / (85) 3101.2284',
          email: 'ouvidoria@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hemocentro Regional de Sobral – HEMOCENTRO REGIONAL SOBRAL',
          operating_hours: 'segunda a sexta-feira, das 7 às 13h',
          address: 'Rua Jânio Quadros, S/N, Santa Casa – Sobral/CE – CEP: 63.010-660',
          phone: '(88) 3677.4624',
          email: 'ouvidoria.sobral@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hemocentro Regional de Crato – HEMOCENTRO REGIONAL CRATO',
          operating_hours: 'segunda a sexta-feira, das 7 às 13h',
          address: 'Rua Coronel Antônio Luiz, 1.111, Pimenta – Crato/CE – CEP: 63.100-000',
          phone: '(88) 3102.1261',
          email: 'ouvidoria.crato@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hemonúcleo de Juazeiro do Norte – HEMONÚCLEO JUAZEIRO DO NORTE',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Beata Maria de Araújo, 30, Romeirão – Juazeiro do Norte/CE – CEP: 63.050-720',
          phone: '(88) 3102.1169',
          email: 'ouvidoria.juazeirodonorte@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hemocentro Regional de Iguatu – HEMOCENTRO REGIONAL IGUATU',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Edilson de Melo Távora, S/N, Vila Centenário – Iguatu/CE – CEP: 63.500-000',
          phone: '(88) 3581.9409',
          email: 'ouvidoria.iguatu@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria do Hemocentro Regional de Quixadá – HEMOCENTRO REGIONAL QUIXADÁ',
          operating_hours: 'segunda a sexta-feira, das 7 às 12h e 13 às 16h',
          address: 'Rua Francisco Almeida Pinheiro, Planalto Universitário – Quixadá/CE – CEP:63.902-125',
          phone: '(88) 3445.1008',
          email: 'ouvidoria.quixada@hemoce.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 1ª Coordenadoria Regional de Saúde – Fortaleza',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13h30 às 17h30',
          address: 'Rua Olavo Bilac, 1200, Presidente Kennedy – Fortaleza/CE – CEP: 60.120-021',
          phone: '(85) 3101.2711',
          email: 'ouvidoriafortaleza@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 5ª Coordenadoria Regional de Saúde – Canindé',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h30 às 17h',
          address: 'Rua Célio Martins 736 – Canindé/CE – CEP: 62.700-000',
          phone: '(85) 3343.6802',
          email: 'ouvidoriacaninde@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 6ª Coordenadoria Regional de Saúde – Itapipoca',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 11h30 e 13h30 às 17h30',
          address: 'Av. Esaú Alves Aguiar, S/N, Fazendinha – Itapipoca/CE – CEP. 62.500-000',
          phone: '(88) 3631.0379',
          email: 'ouvidoriaitapipoca@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 7ª Coordenadoria Regional de Saúde – Aracati',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Vila Isaura, 1, Farias Brito – Aracati/CE – CEP: 62.800-000',
          phone: '(88) 3446.2597',
          email: 'ouvidoriaaracati@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 8ª Coordenadoria Regional de Saúde – Quixadá',
          operating_hours: 'segunda a sexta-feira, das 7 às 13h',
          address: 'Rua Dr. Eudásio Barroso, 847, Centro – Quixadá/CE – CEP: 63.900-000',
          phone: '(88) 3445.1013',
          email: 'ouvidoriaquixada@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 11ª Coordenadoria Regional de Saúde – Sobral',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 11h30 e 13h30 às 17h30',
          address: 'Avenida John Sanfort, 2239 – Sobral/CE – CEP: 62.030-000',
          phone: '(88) 3614.9243',
          email: 'ouvidoriasobral@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 13ª Coordenadoria Regional de Saúde – Tianguá',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h às 16h30',
          address: 'CE 187, km 2, Teixeiras – Tianguá/CE – CEP: 62.320-000',
          phone: '(88) 3671.9300',
          email: 'ouvidoriatiangua@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 15ª Coordenadoria Regional de Saúde – Crateús',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Firmino Rosa, S/N, Centro – Crateús/CE – CEP: 63.700-000',
          phone: '(88) 3692.3375',
          email: 'ouvidoriacrateus@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 17ª Coordenadoria Regional de Saúde – Icó',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h30 às 17h',
          address: 'Rua Raimunda Pereira de Melo, 545, Centro – Icó/CE – CEP: 63.430.000',
          phone: '(88) 3561.5504',
          email: 'ouvidoriaico@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 18ª Coordenadoria Regional de Saúde – Iguatu',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h30 às 17h',
          address: 'Rua 13 de Maio, S/N, Bairro Planalto – Iguatu/CE – CEP: 63.500-000',
          phone: '(88) 3581.9400',
          email: 'ouvidoriaiguatu@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 19ª Coordenadoria Regional de Saúde – Brejo Santo',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h30 às 17h',
          address: 'Rua Manuel Antônio Cabral, 609, Bairro Luzia Leite – Brejo Santo/CE – CEP: 63.260-000',
          phone: '(88) 3531.4804',
          email: 'ouvidoriabrejosanto@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 20ª Coordenadoria Regional de Saúde – Crato',
          operating_hours: 'segunda a sexta-feira, das 13 às 17h',
          address: 'Rua Capitão José Joaquim Macedo, 680, São Miguel – Crato/CE – CEP:63.122-318',
          phone: '(88) 3523.3818/ (88) 3102.1254',
          email: 'ouvidoriacrato@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da 21ª Coordenadoria Regional de Saúde – Juazeiro do Norte',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 14 às 17h',
          address: 'Rua das Flores, 942, Romeirão – Juazeiro do Norte/CE – CEP: 63.050-290',
          phone: '(88) 3102.1160',
          email: 'ouvidoriajuazeiro@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. Francisco Carlos Cavalcante Roque – Quixadá',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 11h30 e 13h30 às 17h',
          address: 'Rua Juscelino Kubitschek, S/N,  Alto São Francisco – Quixadá -CE',
          phone: '(88) 3412.1704',
          email: 'ouvidoriapoliquixada@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. José Hamilton Saraiva Barbosa – Aracati',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 14 às 18h',
          address: 'Rua Armando Praça, 805, Várzea da Matriz – Aracati/CE',
          phone: '(88) 3421.5958',
          email: 'ouvidoriapoliaracati@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. Frutuoso Gomes de Freitas – Tauá',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 14 às 18h',
          address: 'Rua Abigail Cidrão de Oliveira, 190, Colibrís – Tauá /CE – CEP: 63.660-000',
          phone: '(88) 3437.3477',
          email: 'ouvidoria.politaua@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Bernado Félix da Silva – Sobral',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 14 às 18h',
          address: 'Av. Monsenhor Aloísio Pinto, S/N, Dom Expedito – Sobral/CE',
          phone: '(88) 3614.3156',
          email: 'ouvidoriapolisobral@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Regional Dr. Francisco Pinheiro Alves – Itapipoca',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 11h30 e 13h às 17h',
          address: 'Avenida Anastácio Braga, 2405, Fazendinha – Itapipoca/CE – CEP: 62.500-970',
          phone: '(88) 3631.2041',
          email: 'ouvidoria.poliitapipoca@saude.ce.gov.br / ouvidoriaceoitapipoca@saude.ce.gov.br',
        },
        {

          title: 'Ouvidoria da Policlínica Dr. Clóvis Amora Vasconcelos – Baturité',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 12 às 16h',
          address: 'Rua São José, S/N, Centro – Baturité/CE – CEP: 62.760-000',
          phone: '(85) 3347.1837',
          email: 'ouvidoriapolibaturite@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. Plácido Marinho de Andrade – Acaraú',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua José Otacílio Martins Rocha, Monsenhor Edson – Acaraú/CE',
          phone: '(88) 3661.1335',
          email: 'ouvidoriapoliacarau@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. José Martins de Santiago – Russas',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 13 às 17h',
          address: 'Rua Felipe Santiago Lima, 191, Cidade Universitária – Russas/CE',
          phone: '(88) 3411.2529',
          email: 'ouvidoria@cpsmrussas.com.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dra. Márcia Moreira de Meneses – Pacajus',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 12 às 16h',
          address: 'Rua Doca Nogueira, S/N, Centro – Pacajus/CE – CEP: 62.870-000',
          phone: '(85) 3348.3081',
          email: 'ouvidoriapolipacajus@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Regional Raimundo Soares Resende – Crateús',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 13 às 17h',
          address: 'Rua Gustavo Barroso, 853, São Vicente – Crateús/CE – CEP: 637000-00',
          phone: '(88) 3691.2145',
          email: 'ouvidoriapolicrateus@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Policlínica Dr. Manoel Carlos de Gouveia – Iguatu',
          operating_hours: 'segunda a sexta-feira, das 7 às 11h e 13 às 17h',
          address: ' Rua Professor João Monteiro, Santo Antônio, S/N – Iguatu/CE – CEP: 63502-255',
          phone: '(88) 3581.1563',
          email: 'ouvidoriapoliiguatu@saude.ce.gov.br'
        },
        {

          title: 'Policlínica João Pereira dos Santos – Barbalha',
          operating_hours: 'segunda a sexta-feira, das 7 às 13h',
          address: 'Avenida Leão Sampaio, S/N, Parque Bulandeira – Barbalha/CE',
          phone: '(88) 3252.3386',
          email: 'ouvidoriapolibarbalha@saude.ce.gov.br'
        },
        {

          title: 'Policlínica Judite Chaves Saraiva – Limoeiro do Norte',
          operating_hours: 'segunda a sexta-feira, das 7 às 15h',
          address: 'Rua Napoleão Nunes Maia, S/N, Bairro José Simões – Limoeiro do Norte/CE – CEP: 62.930-300',
          phone: '(88) 3423.4938/ 3423.2708',
          email: 'ouvidoriapolilimoeirodonorte@saude.ce.gov.br / ouvidoriaceolimoeiro@saude.ce.gov.br'
        },
        {

          title: 'Policlínica  Dr. Francisco Edvaldo Coêlho Moita – Tianguá',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h',
          address: 'Rodovia CE 187, Km 03, Frecheiras – Tianguá/CE – CEP. 62.320-000',
          phone: '(88) 3671.2704',
          email: 'ouvidoriapolitiangua@saude.ce.gov.br'
        },
        {

          title: 'Policlínica Dr. Sebastião Limeira Guedes – Policlínica Icó',
          operating_hours: 'segunda a sexta-feira das 08h às 12h e das 13h às 17h.',
          address: 'Benjamin Constant, S/N, Cidade Nova – Icó/CE – CEP. 63.430-000',
          phone: '(88) 3561.4747',
          email: 'ouvidoriapoliico@saude.ce.gov.br'
        },
        {

          title: 'Policlínica Bárbara Pereira de Alencar – Campos Sales',
          operating_hours: 'segunda a sexta-feira, das 7h30 às 12h e 13h às 16h30',
          address: 'Rua José Alves, S/N, Alto Alegre – CEP: 63.150-000',
          phone: '(88) 3533.2507',
          email: 'ouvidoriapolicamposales@saude.ce.gov.br'
        },
        {

          title: 'Ouvidoria da Unidade de Pronto Atendimento – UPA',
          operating_hours: 'segunda a sexta-feira, das 8 às 12h e 13 às 17h',
          address: 'Rua Socorro Gomes, S/N, Guajeru – Fortaleza/CE – CEP. 60.843-070',
          phone: '(85) 3195.2721',
          email: 'ouvidoriaupa@isgh.org.br'
        }
      ]

      ombudsmen.each do |item|
        ombudsman = SesaOmbudsman.find_or_initialize_by(title: item[:title])
        ombudsman.attributes = item

        ombudsman.save
       end
    end
  end
end


