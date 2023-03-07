# Views

## Aspectos Gerais

Os templates para um controller padrão são: 
- `index`
- `new`
- `show`
- `edit` 

E as partials (partes de templates usados para extrair pedaços do template original ou para reutilização):
- `_show`: Extrai a apresentação do recurso do template `show`
- `_resource`: Usado para renderizar cada recurso do template `index`
- `_form`: Formulário do recurso que é compartilhado entre os templates `new` e  `edit`

## Boas práticas

- Nunca colocar textos diretamente na view, sempre deixar os textos localizáveis.
- Deixa pouca ou nenhuma lógica de negócio na view, quando necessário, criar um [helper de view](helpers.md) com a lógica e usar o método no template.
- Acessar os recursos e infos do controller através de [helpers de controller](controllers.md).
- Partials devem sempre receber as variávies locais. Ex: `= render 'form', resource: resource`
