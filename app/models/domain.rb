class Domain < ActiveRecord::Base
  belongs_to :user

  def self.allows?(domain)
    Domain.where("name ~ ?", without_www(domain)).present?
  end

  private
  def self.without_www(domain)
    domain.match(/(www\.)?(.*)/)[2]
  end
end
