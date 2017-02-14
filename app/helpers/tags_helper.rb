module TagsHelper
  def self.find_tag_like_name(name)
      return Tag.where('name like ?', "%#{name}%").to_a
  end
end
