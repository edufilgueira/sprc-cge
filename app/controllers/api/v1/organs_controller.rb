# RESTful API pública de órgãos
#
# 1) INDEX
#    GET /api/v1/organs
#    HTTP 200 - [ { organ }, { organ }, ... ]
#
# DOCUMENTAÇÃO COMPLETA: hhttps://github.com/caiena/sprc/wiki/API-doc-org%C3%A3os
class Api::V1::OrgansController < Api::V1::ApplicationController

  def index
    object_response(sorted_resources)
  end


  private

  def sorted_resources
    resources.sorted
  end

  def resources
    @resources ||= ExecutiveOrgan.enabled
  end

end
