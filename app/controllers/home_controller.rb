class HomeController < ApplicationController
  def index
    @acros = Post.find_by_room(Settings.mmr.acros.name, :order => "created_at DESC")
    @prism = Post.find_by_room(Settings.mmr.prism.name, :order => "created_at DESC")
    @media = Post.find_by_room(Settings.mmr.media.name, :order => "created_at DESC")
    @other = Post.find_by_room(Settings.mmr.other.name, :order => "created_at DESC")

    @acros = @acros.nil? ? -1 : @acros.to_api['outdated'] ? -1 : @acros[:rate]
    @prism = @prism.nil? ? -1 : @prism.to_api['outdated'] ? -1 : @prism[:rate]
    @media = @media.nil? ? -1 : @media.to_api['outdated'] ? -1 : @media[:rate]
    @other = @other.nil? ? -1 : @other.to_api['outdated'] ? -1 : @other[:rate]

    respond_to do |format|
      format.html
    end
  end
end
