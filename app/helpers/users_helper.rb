module UsersHelper
  def gravartar_for user, options = {size: Settings.gravartar.size_default}
    size = options[:size]
    gravartar_id = Digest::MD5.hexdigest user.email.downcase
    gravartar_url = Settings.links.gravartar + gravartar_id +
                    format(Settings.gravartar.options_link, size: size)
    image_tag gravartar_url, alt: user.name, class: "gravartar"
  end
end
