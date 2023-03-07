require_dependency 'ppa/interaction'

module PPA
  class Comment < Interaction

    validates :content, presence: true

    def content=(content)
      data['content'] = content
    end

    def content
      data['content']
    end

  end
end
