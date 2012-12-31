# -*- coding: utf-8 -*-
class PostsController < ApplicationController
  before_filter :authenticate_user!

  # GET /posts
  # GET /posts.json
  def index

    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    
    # 計算
    @tmp = calc(params[:post])
    @post = Post.new(@tmp)

    respond_to do |format|
      if @post.valid?
        if @post.save
          format.html { redirect_to @post, :notice => 'Post was successfully created.' }
          format.json { render :json => @post, :status => :created, :location => @post }
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    
    @post = Post.find(params[:id])
    @tmp = calc(params[:post])

    respond_to do |format|
        if @post.update_attributes(@tmp)
          if @post.valid?
          # 計算
          @post = calc(@post)

          # 更新(気合)
          @post.update_attribute(:rate, @post.rate)
          @post.update_attribute(:windows, @post.windows)
          @post.update_attribute(:linux, @post.linux)

          format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
          format.json { head :no_content }
        end
      else
          format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  # 計算
  def calc(params)

    # 部屋の最大人数に関して
    if params[:room] == Settings.mmr.acros.name
      params[:available] = Settings.mmr.acros.size - params[:unavailable].to_i
    elsif params[:room] == Settings.mmr.prism.name
      params[:available] = Settings.mmr.prism.size - params[:unavailable].to_i
    elsif params[:room] == Settings.mmr.media.name
      params[:available] = Settings.mmr.media.size - params[:unavailable].to_i
    elsif params[:room] == Settings.mmr.other.name
      params[:available] = Settings.mmr.other.size - params[:unavailable].to_i
    end

    # 利用率に関して
    if params[:calc_base]           # 利用証ベース
      params[:rate] = (params[:available].to_i - params[:users].to_i).to_f / params[:available].to_i * 100
      if params[:windows] != "" && params[:linux] != "" && (params[:windows].to_i != 0 && params[:linux].to_i != 0)
        params[:windows] = (params[:windows].to_f / (params[:windows].to_i + params[:linux].to_i)) * (params[:available].to_i - params[:users].to_i)
        params[:linux] = (params[:available].to_i - params[:users].to_i) - params[:windows].to_i
      end
    else                        # 利用者ベース
      params[:rate] = params[:users].to_f / params[:available].to_i * 100
      if params[:windows] != "" && params[:linux] != "" && (params[:windows] != 0 && params[:linux] != 0)
        params[:windows] = (params[:windows].to_f / (params[:windows].to_i + params[:linux].to_i)) * params[:users].to_i
        params[:linux] = params[:users].to_i - params[:windows].to_i
      end
    end

    return params
  end
end
