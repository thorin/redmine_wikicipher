require 'digest'
require 'openssl'

namespace :redmine do
  namespace :plugins do
    namespace :wikicipher do

      desc 'Update the *secret key*'
      task :updatekey, [:old_key, :new_key] => :environment do |t, args|
        begin
          old_key = Digest::SHA256.hexdigest(args[:old_key])
          new_key = Digest::SHA256.hexdigest(args[:new_key]) if args.has_key? :new_key

          [WikiContent, WikiContent::Version].each do |content_class|
            puts "UPDATING #{content_class.table_name}"
            content_class.all.each do |content|
              next if content.text.nil?

              text = content.text.gsub /\{{cipher\(1\)(.+?)}}/m do
                plain_text = decrypt $1.strip, old_key

                if new_key.present?
                  "{{cipher(1)\n#{encrypt plain_text, new_key}\n}}"
                else
                  "*#{plain_text}*"
                end
              end

              content.update_attributes(:text => text) if text != content.text
            end
          end
        rescue OpenSSL::Cipher::CipherError => e
          puts "Wrong key provided\n"
          puts e
        end
      end

      def decrypt(text,key)
        e = OpenSSL::Cipher::Cipher.new 'DES-EDE3-CBC'
        e.decrypt key
        s = text.lines.to_a.pack("H*").unpack("C*").pack("c*")
        s = e.update s
        s << e.final
      end

      def encrypt(text,key)
        e = OpenSSL::Cipher::Cipher.new 'DES-EDE3-CBC'
        e.encrypt key
        s = e.update text
        s << e.final
        s.unpack('H*')[0].upcase
      end

    end
  end
end