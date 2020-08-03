module UsersHelper
  def gravartar_for user
    gravartar_id = Digest::MD5.hexdigest user.email.downcase
    gravartar_url = Settings.links.gravartar + gravartar_id
    image_tag gravartar_url, alt: user.name, class: "gravartar"
  end
end
