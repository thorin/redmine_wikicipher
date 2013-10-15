module Wikicipher::Macros
  Redmine::WikiFormatting::Macros.register do

    desc "Encrypts its content on the database upon save."
    macro :cipher do |obj, args, text|
      encrypted = args.first == '1'

      if encrypted
        content_tag :span, :class => 'wikicipher encrypted' do
          content_tag(:span, t('wikicipher.coded'), :class => 'coded-label') +
          content_tag(:span, text, :class => 'wikicipher-content')
        end
      else
        content_tag :span, text, :class => 'decoded'
      end
    end

  end
end