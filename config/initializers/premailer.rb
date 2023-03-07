# Sugestão da wiki em https://github.com/fphilipe/premailer-rails#configuration
#
# Veja opções disponíveis em https://github.com/premailer/premailer/wiki/Premailer-Parameters-and-Options
#
Premailer::Rails.config.merge! preserve_styles: false,
                               remove_ids: true,
                               remove_comments: true
