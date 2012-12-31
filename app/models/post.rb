# -*- coding: utf-8 -*-
class Post < ActiveRecord::Base
  attr_accessible :available, :linux, :users, :rate, :room, :unavailable, :windows, :calc_base

  validates :rate, :numericality => true, :inclusion => { :in => 0..100, :message => "利用者数や利用不可端末数を確認してみてください" }
  validates :users, :numericality => true, :presence => true
  validates :unavailable, :numericality => true, :presence => true
  validates :windows, :numericality => true, :presence => true
  validates :linux, :numericality => true, :presence => true

  def to_hash
    ActiveSupport::JSON.decode(self.to_json)
  end

  def to_api
    model = ActiveSupport::JSON.decode(self.to_json)

    h = Hash::new
    h[:rate] = self.rate
    h[:users] = self.users
    h[:available] = self.available
    h[:windows] = self.windows
    h[:linux] = self.linux
    h['outdated'] = Time.now - self.created_at > 1.hours # 有用なデータか?

    return h
  end
end
