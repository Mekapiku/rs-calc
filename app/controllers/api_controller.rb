class ApiController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        @acros = Post.find_by_room(Settings.mmr.acros.name, :order => "created_at DESC")
        @prism = Post.find_by_room(Settings.mmr.prism.name, :order => "created_at DESC")
        @media = Post.find_by_room(Settings.mmr.media.name, :order => "created_at DESC")
        @other = Post.find_by_room(Settings.mmr.other.name, :order => "created_at DESC")

        @acros = @acros.to_api unless @acros.nil?
        @prism = @prism.to_api unless @prism.nil?
        @media = @media.to_api unless @media.nil?
        @other = @other.to_api unless @other.nil?

        @posts = { Settings.mmr.acros.name => @acros, Settings.mmr.prism.name => @prism, Settings.mmr.media.name => @media, Settings.mmr.other.name=> @other }
        render :json => @posts
      }
    end
  end
end
