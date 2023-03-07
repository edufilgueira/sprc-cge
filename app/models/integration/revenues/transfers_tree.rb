#
# Representação em árvores de receitas para transferencias
#
#

class Integration::Revenues::TransfersTree < Integration::Revenues::RevenuesTree

  NODES_TYPES = {
    secretary: Integration::Revenues::RevenuesTreeNodes::Secretary,
    organ: Integration::Revenues::RevenuesTreeNodes::Organ,
    transfer: Integration::Revenues::TransfersTreeNodes::Transfer
  }

end
