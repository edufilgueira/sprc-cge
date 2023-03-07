# Shared example para controllers com escopo de região e biênio
#
# Basta incluir a chamada it_behaves_like 'region with biennium'
# dentro do spec. Esses exemplos necessitam que seja feita uma chamada
# para a action em si (ex: before { get: :index }).
#
# Caso não exista a chamada em si é possível passar ela diretamente
# para o `shared example` usando um bloco
#
# it_behaves_like 'region with biennium' { get(:index, params...) }
#
# Parâmetros esperados dentro da key :params da chamada
#
# @param region_code [String] código de uma PPA::Region (#code)
# @param biennium [String] formato '2010-2011', normalmente representando período de um PPA::Plan

shared_examples_for 'region with biennium' do
  it 'has a current_biennium' do
    expect(controller.current_biennium).to be_kind_of(PPA::Biennium)
  end

  it 'has a current_region' do
    expect(controller.current_region).to be_kind_of(PPA::Region)
  end

  it 'has a current_plan' do
    expect(controller.current_plan).to be_kind_of(PPA::Plan)
  end
end
