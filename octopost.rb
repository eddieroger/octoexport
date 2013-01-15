require 'jekyll'

class OctoPost

  include Jekyll::Convertible

  attr_accessor :content, :data


end