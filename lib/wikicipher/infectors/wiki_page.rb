require 'redmine'
# encoding: utf-8
module Wikicipher::Infectors::WikiPage
  module InstanceMethods
    include Wikicipher::Encryption

    def encrypt_ciphers
      content.text.gsub! /\{{cipher\(0\)(.+?)}}/m do
        "{{cipher(1)\n#{encrypt $1.strip}\n}}"
      end if text
    end
  end
  def self.included(receiver) # :nodoc:
    receiver.send(:include, InstanceMethods)

    receiver.instance_eval do
      before_save 'encrypt_ciphers'
    end
  end
end
